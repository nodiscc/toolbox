#!/usr/bin/env python3
# requirements: python3-tqdm python3-send2trash
import os
from tqdm import tqdm
import random
import subprocess
import shutil
import datetime
import uuid
from send2trash import send2trash

KEEP_DIRECTORY = './KEEP'
ARCHIVE_DIRECTORY = './ARCHIVE'
TODO_DIRECTORY = './TODO'

def format_size(size_bytes: int) -> str:
    """Return a human‑readable file size.

    Uses powers of 1024 and rounds to one decimal place. Handles 0‑byte
    files gracefully (``0.0B``)."""
    for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
        if size_bytes < 1024:
            return f"{size_bytes:.1f}{unit}"
        size_bytes //= 1024
    return f"{size_bytes:.1f}PB"

def get_file_info(filename):
    stat = os.stat(filename)
    size = format_size(stat.st_size)
    mtime = datetime.datetime.fromtimestamp(stat.st_mtime).strftime('%Y-%m-%d %H:%M')
    ext = os.path.splitext(filename)[1].upper() if os.path.splitext(filename)[1] else 'FILE'
    return size, mtime, ext



def ask_user_action(filename):
    size, mtime, ext = get_file_info(filename)
    while True:
        print(f"File: {filename} | Size: {size} | Modified: {mtime} | Type: {ext}")
        choice = input("Action: \033[32m[k]\033[0m keep (not important), \033[32m[a]\033[0m archive (important), \033[32m[d]\033[0m delete, \033[32m[t]\033[0m add to TODO, \033[32m[o]\033[0m open file, \033[32m[n]\033[0m do nothing, \033[32m[q]\033[0m quit batch mode: ").lower().strip()

        if choice not in ['k', 'a', 'd', 't', 'o', 'n', 'q']:
            print("Invalid choice. Please choose from k, a, d, t, o, n, q")
            continue

        if choice == 'o':
            subprocess.run(['xdg-open', filename])
            continue

        return choice

def ensure_directory_exists(directory):
    if not os.path.exists(directory):
        os.makedirs(directory)

def move_with_unique(src: str, dst_dir: str):
    """Move *src* into *dst_dir*, adding a UUID suffix if a file with the same name already exists.

    Parameters
    ----------
    src: str
        Path to the source file.
    dst_dir: str
        Destination directory.

    The function creates the destination directory if it does not exist.
    """
    dst_dir_path = os.path.abspath(dst_dir)
    if not os.path.isdir(dst_dir_path):
        os.makedirs(dst_dir_path, exist_ok=True)
    base_name = os.path.basename(src)
    dst_path = os.path.join(dst_dir_path, base_name)
    if os.path.exists(dst_path):
        name, ext = os.path.splitext(base_name)
        unique_suffix = uuid.uuid4().hex[:8]
        dst_path = os.path.join(dst_dir_path, f"{name}_{unique_suffix}{ext}")
    shutil.move(src, dst_path)

def process_file(filename):
    action = ask_user_action(filename)

    print(f"Selected action: {action} for file: {filename}")

    if action == 'q':
        return False

    if action == 'k':
        move_with_unique(filename, KEEP_DIRECTORY)
        print(f"Moved {filename} to {KEEP_DIRECTORY}")
    elif action == 'a':
        move_with_unique(filename, ARCHIVE_DIRECTORY)
        print(f"Moved {filename} to {ARCHIVE_DIRECTORY}")
    elif action == 'd':
        send2trash(filename)
        print(f"Deleted {filename}")
    elif action == 't':
        move_with_unique(filename, TODO_DIRECTORY)
        print(f"Moved {filename} to {TODO_DIRECTORY}")
    elif action == 'n':
        print(f"Doing nothing with {filename}")

    return True

def main():
    ensure_directory_exists(KEEP_DIRECTORY)
    ensure_directory_exists(ARCHIVE_DIRECTORY)
    ensure_directory_exists(TODO_DIRECTORY)

    files = [f for f in os.listdir('.') if os.path.isfile(f)]
    if not files:
        print("No files found in current directory")
        return

    print(f"Starting batch file sorter mode. Found {len(files)} files to process. Press [q] to quit.")

    with tqdm(total=len(files), ncols=80, desc="Processing files", unit="file") as pbar:
        while files:
            filename = random.choice(files)
            files.remove(filename)

            if not os.path.exists(filename):
                continue

            print(f"\n--- Processing file #{len(files)} remaining ---")

            if not process_file(filename):
                print("Exiting batch mode.")
                break
            pbar.update(1)

if __name__ == "__main__":
    main()