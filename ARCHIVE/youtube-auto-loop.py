# Source: https://nitter.nl/ColugoMusic/status/1726001266180956440, https://pastebin.com/p0ehXsFN
# Requirements: pip install pydub isodate - search words list in words.txt
# Description: finds a random youtube video and downloads a tiny fragment from the middle and generates a looping sample and then repeats the process over and over until your hard drive fills with garbage
# License: WTFPL
from pydub import AudioSegment, effects
from yt_dlp import YoutubeDL
import glob
import isodate
import os
import random
import subprocess
import wave

BATCH_SIZE         = 32
MAX_SEARCH_RESULTS = 10
DOWNLOAD_DIR         = 'wavs/raw'
LOOP_OUTPUT_DIR      = 'wavs/processed/loop'
ONESHOT_OUTPUT_DIR   = 'wavs/processed/oneshot'
WORD_LIST            = 'words.txt'

def read_lines(file):
  return open(file).read().splitlines()

class download_range_func:
  def __init__(self):
    pass
  def __call__(self, info_dict, ydl):
    timestamp = self.make_timestamp(info_dict)
    yield {
        'start_time': timestamp,
        'end_time': timestamp,
    }
  @staticmethod
  def make_timestamp(info):
      duration = info['duration']
      if duration is None:
        return 0
      return duration/2

def make_random_search_phrase(word_list):
  words = random.sample(word_list, 2)
  phrase = ' '.join(words)
  print('Search phrase: "{}"'.format(phrase))
  return phrase

def make_download_options():
  return {
    'format': 'bestaudio/best',
    'paths': {'home': DOWNLOAD_DIR},
    'outtmpl': {'default': '%(id)s.%(ext)s'},
    'download_ranges': download_range_func(),
    'postprocessors': [{
        'key': 'FFmpegExtractAudio',
        'preferredcodec': 'wav',
    }]
  }

def make_oneshot(sound, output_filepath):
  final_length = min(2000, len(sound))
  quarter = int(final_length/4)
  sound   = sound[:final_length]
  sound   = sound.fade_out(duration=quarter)
  sound   = effects.normalize(sound)
  sound.export(output_filepath, format="wav")

def make_loop(sound, output_filepath):
    final_length = min(2000, len(sound))
    half         = int(final_length/2)
    fade_length  = int(final_length/4)
    beg   = sound[:half]
    end   = sound[half:]
    end   = end[:fade_length]
    beg   = beg.fade_in(duration=fade_length)
    end   = end.fade_out(duration=fade_length)
    sound = beg.overlay(end)
    sound = effects.normalize(sound)
    sound.export(output_filepath, format="wav")

def process_file(filepath):
  try:
    filename                = os.path.basename(filepath)
    output_filepath_oneshot = os.path.join(ONESHOT_OUTPUT_DIR, 'oneshot_' + filename)
    output_filepath_loop    = os.path.join(LOOP_OUTPUT_DIR, 'loop_' + filename)
    sound                   = AudioSegment.from_file(filepath, "wav")
    if (len(sound) > 500):
      if not os.path.exists(output_filepath_oneshot):
        make_oneshot(sound, output_filepath_oneshot)
      if not os.path.exists(output_filepath_loop):
        make_loop(sound, output_filepath_loop)
    os.remove(filepath)
  except Exception as err:
    print("Failed to process '{}' ({})".format(filepath, err))

def setup():
    if not os.path.exists(LOOP_OUTPUT_DIR):
      os.makedirs(LOOP_OUTPUT_DIR)
    if not os.path.exists(ONESHOT_OUTPUT_DIR):
      os.makedirs(ONESHOT_OUTPUT_DIR)

def main():
  try:
    setup()
    word_list = read_lines(WORD_LIST)
    for _ in range(BATCH_SIZE):
      phrase    = make_random_search_phrase(word_list)
      video_url = 'ytsearch1:"{}"'.format(phrase)
      YoutubeDL(make_download_options()).download([video_url])
      for filepath in glob.glob(os.path.join(DOWNLOAD_DIR, '*.wav')):
        process_file(filepath)
  except Exception as err:
     print('FATAL ERROR: {}'.format(err))

if __name__ == '__main__':
  main()