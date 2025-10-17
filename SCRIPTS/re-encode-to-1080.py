#!/usr/bin/env python3
import os
import subprocess
import sys

def get_video_resolution(video_path):
    """Get video resolution using ffprobe."""
    try:
        cmd = [
            'ffprobe',
            '-v', 'error',
            '-select_streams', 'v:0',
            '-show_entries', 'stream=width,height',
            '-of', 'csv=p=0',
            video_path
        ]
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        width, height = map(int, result.stdout.strip().split(','))
        return width, height
    except Exception as e:
        print(f"Error getting resolution for {video_path}: {e}")
        return None, None

def play_video(video_path):
    """Play video using mpv."""
    try:
        print(f"[INFO] Playing video in mpv...")
        subprocess.run(['mpv', video_path], check=True)
    except subprocess.CalledProcessError:
        print("[INFO] mpv closed.")
    except FileNotFoundError:
        print("[ERROR] mpv not found. Please install mpv to use the preview feature.")

def reencode_to_1080p(video_path):
    """Re-encode video to 1080p width using ffmpeg with VP9 codec."""
    base_name, ext = os.path.splitext(video_path)
    output_path = f"{base_name}_1080p.webm"  # VP9 typically uses .webm container
    
    cmd = [
        'ffmpeg',
        '-i', video_path,
        '-vf', 'scale=-2:1080',  # -2 ensures height is divisible by 2
        '-c:v', 'libvpx-vp9',    # VP9 video codec
        '-crf', '30',            # CRF for VP9 (30 is good quality)
        '-b:v', '0',             # Variable bitrate mode
        '-row-mt', '1',          # Enable row-based multithreading
        '-threads', '4',         # Use multiple threads
        '-c:a', 'copy',          # Copy audio without re-encoding
        output_path
    ]
    
    print(f"[INFO] Re-encoding to {output_path} using VP9 codec...")
    try:
        subprocess.run(cmd, check=True)
        print(f"[INFO] Successfully created {output_path}")
    except subprocess.CalledProcessError as e:
        print(f"[ERROR] Failed to re-encode: {e}")

def ask_reencode(video_path):
    """Ask user if they want to re-encode, with option to preview."""
    while True:
        response = input(f"[INFO] Height exceeds 1080p. Re-encode to 1080p? (y/n/p to preview): ").strip().lower()
        
        if response == 'y':
            return True
        elif response == 'n':
            return False
        elif response == 'p':
            play_video(video_path)
            # Loop continues, asking again
        else:
            print("[ERROR] Invalid choice. Please enter 'y', 'n', or 'p'.")

def process_videos(directory):
    """Find and process all video files in directory."""
    video_extensions = ('.mp4', '.avi', '.mkv', '.mov', '.flv', '.wmv', '.webm', '.m4v')
    
    for filename in os.listdir(directory):
        if filename.lower().endswith(video_extensions):
            video_path = os.path.join(directory, filename)
            print(f"\n[INFO] Processing: {filename}")
            
            width, height = get_video_resolution(video_path)
            
            if width is None or height is None:
                continue
            
            max_dimension = max(width, height)
            print(f"[INFO] Current resolution: {width}x{height}")
            
            if height > 1080:
                if ask_reencode(video_path):
                    reencode_to_1080p(video_path)
                else:
                    print("[INFO] Skipping re-encoding.")

if __name__ == "__main__":
    directory = input("Enter directory path (or press Enter for current directory): ").strip()
    
    if not directory:
        directory = os.getcwd()
    
    if not os.path.isdir(directory):
        print(f"[ERROR] Directory not found: {directory}")
        sys.exit(1)
    
    print(f"[INFO] Scanning directory: {directory}")
    process_videos(directory)
    print("\n[INFO] Processing complete!")
