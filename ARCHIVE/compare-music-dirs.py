#!/usr/bin/env python3
"""
Compare two music directories by analyzing their audio file contents.

This script compares two directories containing audio files and reports:
- Number of audio files
- Total runtime
- Disk usage
- Mean bitrate

Supported audio formats: MP3, FLAC, WAV, M4A, OGG, AAC, Opus
"""

import sys
from pathlib import Path
from mutagen import File

def get_audio_info(directory):
    """
    Analyze audio files in a directory and return statistics.
    
    Args:
        directory (str): Path to directory containing audio files
        
    Returns:
        tuple: (audio_files, total_duration, total_size, mean_bitrate, format_counts, track_names)
            - audio_files (int): Count of audio files found
            - total_duration (float): Total duration in seconds
            - total_size (int): Total file size in bytes
            - mean_bitrate (float): Average bitrate in kbps
            - format_counts (dict): Dictionary counting files by format
            - track_names (set): Set of normalized track names for comparison
    """
    audio_files = 0
    total_duration = 0
    total_size = 0
    total_bitrate = 0
    bitrate_count = 0
    format_counts = {}
    track_names = set()
    dir_path = Path(directory)
    
    for filepath in dir_path.rglob('*'):
        if filepath.is_file() and filepath.suffix.lower() in {'.mp3', '.flac', '.wav', '.m4a', '.ogg', '.aac', '.opus'}:
            try:
                audio = File(str(filepath))
                if audio and hasattr(audio, 'info') and audio.info:
                    audio_files += 1
                    total_duration += audio.info.length
                    total_size += filepath.stat().st_size
                    
                    # Count formats
                    format_ext = filepath.suffix.lower()[1:].upper()  # Remove dot and uppercase
                    format_counts[format_ext] = format_counts.get(format_ext, 0) + 1
                    
                    # Extract and normalize track name for comparison
                    track_name = filepath.stem
                    # Remove common prefixes and normalize spaces/underscores
                    normalized_name = track_name.lower()
                    # Remove artist prefix and soundcloud info
                    if ' - ' in normalized_name:
                        parts = normalized_name.split(' - ', 1)
                        if len(parts) > 1:
                            normalized_name = parts[1]
                    # Remove soundcloud identifier
                    if ' soundcloud-' in normalized_name:
                        normalized_name = normalized_name.split(' soundcloud-')[0]
                    # Normalize spaces and underscores
                    normalized_name = normalized_name.replace('_', ' ').strip()
                    track_names.add(normalized_name)
                    
                    if hasattr(audio.info, 'bitrate') and audio.info.bitrate:
                        # Convert bitrate to kbps (mutagen reports in bps for most formats)
                        bitrate = audio.info.bitrate
                        if bitrate > 10000:  # Likely in bps, convert to kbps
                            bitrate = bitrate / 1000
                        total_bitrate += bitrate
                        bitrate_count += 1
                    else:
                        # Calculate approximate bitrate for formats without direct bitrate info
                        try:
                            if filepath.stat().st_size > 0 and audio.info.length > 0:
                                approx_bitrate = (filepath.stat().st_size * 8) / audio.info.length / 1000
                                total_bitrate += approx_bitrate
                                bitrate_count += 1
                        except:
                            pass
            except:
                pass
    
    mean_bitrate = total_bitrate / bitrate_count if bitrate_count > 0 else 0
    return audio_files, total_duration, total_size, mean_bitrate, format_counts, track_names

def format_duration(seconds):
    """
    Convert duration in seconds to HH:MM:SS format.
    
    Args:
        seconds (float): Duration in seconds
        
    Returns:
        str: Formatted time string
    """
    hours = int(seconds // 3600)
    minutes = int((seconds % 3600) // 60)
    secs = int(seconds % 60)
    return f"{hours:02d}:{minutes:02d}:{secs:02d}"

def format_size(bytes_size):
    """
    Convert file size in bytes to human-readable format.
    
    Args:
        bytes_size (int): Size in bytes
        
    Returns:
        str: Human-readable size string (B, KB, MB, GB, or TB)
    """
    for unit in ['B', 'KB', 'MB', 'GB']:
        if bytes_size < 1024.0:
            return f"{bytes_size:.1f} {unit}"
        bytes_size /= 1024.0
    return f"{bytes_size:.1f} TB"

def compare_directories(dir1, dir2):
    """
    Compare two directories and print their audio statistics.
    
    Args:
        dir1 (str): Path to first directory
        dir2 (str): Path to second directory
    """
    files1, duration1, size1, bitrate1, formats1, tracks1 = get_audio_info(dir1)
    files2, duration2, size2, bitrate2, formats2, tracks2 = get_audio_info(dir2)
    
    print(f"Directory 1 ({Path(dir1).name}):")
    print(f"  Audio files: {files1}")
    print(f"  Total runtime: {format_duration(duration1)}")
    print(f"  Disk usage: {format_size(size1)}")
    print(f"  Mean bitrate: {bitrate1:.0f} kbps")
    print(f"  Formats: {', '.join(f'{count} {fmt}' for fmt, count in sorted(formats1.items()))}")
    print(f"\nDirectory 2 ({Path(dir2).name}):")
    print(f"  Audio files: {files2}")
    print(f"  Total runtime: {format_duration(duration2)}")
    print(f"  Disk usage: {format_size(size2)}")
    print(f"  Mean bitrate: {bitrate2:.0f} kbps")
    print(f"  Formats: {', '.join(f'{count} {fmt}' for fmt, count in sorted(formats2.items()))}")

def compare_tracks(dir1, dir2):
    """
    Compare track lists between two directories and show differences.
    
    Args:
        dir1 (str): Path to first directory
        dir2 (str): Path to second directory
    """
    files1, duration1, size1, bitrate1, formats1, tracks1 = get_audio_info(dir1)
    files2, duration2, size2, bitrate2, formats2, tracks2 = get_audio_info(dir2)
    
    print(f"\nTrack Comparison:")
    missing_from_dir2 = tracks1 - tracks2
    missing_from_dir1 = tracks2 - tracks1
    common_tracks = tracks1 & tracks2
    
    print(f"  Common tracks: {len(common_tracks)}")
    if missing_from_dir2:
        print(f"  Missing from {Path(dir2).name} ({len(missing_from_dir2)}):")
        for track in sorted(missing_from_dir2):
            print(f"    - {track}")
    if missing_from_dir1:
        print(f"  Missing from {Path(dir1).name} ({len(missing_from_dir1)}):")
        for track in sorted(missing_from_dir1):
            print(f"    - {track}")
    
    if not missing_from_dir1 and not missing_from_dir2:
        print("  ✅ Both directories contain the same tracks")
    else:
        print(f"  ⚠️  Track count difference: {len(tracks1)} vs {len(tracks2)}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 compare-music-dirs.py [--compare-tracks] <dir1> <dir2>")
        print("  --compare-tracks  Show detailed track comparison between directories")
        sys.exit(1)
    
    compare_tracks_flag = False
    
    if sys.argv[1] == "--compare-tracks":
        if len(sys.argv) != 4:
            print("Usage: python3 compare-music-dirs.py --compare-tracks <dir1> <dir2>")
            sys.exit(1)
        compare_tracks_flag = True
        dir1, dir2 = sys.argv[2], sys.argv[3]
    else:
        if len(sys.argv) != 3:
            print("Usage: python3 compare-music-dirs.py [--compare-tracks] <dir1> <dir2>")
            sys.exit(1)
        dir1, dir2 = sys.argv[1], sys.argv[2]
    
    if not Path(dir1).is_dir() or not Path(dir2).is_dir():
        print("Both arguments must be valid directories")
        sys.exit(1)
    
    compare_directories(dir1, dir2)
    
    if compare_tracks_flag:
        compare_tracks(dir1, dir2)
