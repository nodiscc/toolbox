#!/usr/bin/env python3
"""
Interactive Coding Assistant using llama.cpp server via llama-cpp-python
Refactored with separated concerns for better maintainability
"""

import json
import os
import subprocess
import sys
from datetime import datetime
from typing import Optional, Dict, Any, List, Tuple
import difflib
import fnmatch
import re

try:
    from openai import OpenAI
except ImportError:
    print("Error: openai library not found.")
    print("Install with: pip install openai")
    sys.exit(1)

try:
    import readline
    READLINE_AVAILABLE = True
except ImportError:
    READLINE_AVAILABLE = False

# ============================================================================
# Constants and Configuration
# ============================================================================

# Display Constants
MAX_DISPLAY_VALUE_LENGTH = 200
DIFF_CONTEXT_LINES = 3
BOX_WIDTH = 40

# API Configuration
DEFAULT_SERVER_URL = "http://127.0.0.1:8033"
DEFAULT_MODEL = "openai_gpt-oss-20b-MXFP4"
DEFAULT_TEMPERATURE = 0.7
DEFAULT_MAX_TOKENS = 2000
API_TIMEOUT = 30

# Application Configuration
MAX_ITERATIONS = 10
MAX_HISTORY_SIZE = 1000
SHOW_THINKING = True
STREAM_OUTPUT = True

# Search Configuration
DEFAULT_MAX_SEARCH_RESULTS = 100
DEFAULT_CONTEXT_LINES = 0

# File Size Units
FILE_SIZE_UNITS = ['B', 'KB', 'MB', 'GB', 'TB']
FILE_SIZE_DIVISOR = 1024.0

# ============================================================================
# ANSI Color Codes
# ============================================================================

class Colors:
    """ANSI color codes for terminal output"""
    RESET = '\033[0m'
    USER = '\033[94m'      # Blue
    ASSISTANT = '\033[92m' # Green
    TOOL = '\033[93m'      # Yellow
    ERROR = '\033[91m'     # Red
    THINKING = '\033[95m'  # Magenta
    SYSTEM = '\033[96m'    # Cyan
    DIFF_ADD = '\033[92m'  # Green for additions
    DIFF_DEL = '\033[91m'  # Red for deletions
    DIFF_INFO = '\033[96m' # Cyan for diff info


# ============================================================================
# Utility Functions
# ============================================================================

def colored(text: str, color: str) -> str:
    """Wrap text with color codes"""
    return f"{color}{text}{Colors.RESET}"


# ============================================================================
# Box Drawing Helper
# ============================================================================

class BoxDrawer:
    """Helper class for drawing formatted boxes"""
    
    @staticmethod
    def draw_box(title: str, width: int = BOX_WIDTH, color: str = Colors.SYSTEM) -> str:
        """Draw a box header with title"""
        # Calculate padding for centered title
        title_with_spaces = f"  {title}  "
        padding = width - len(title_with_spaces) - 2
        left_pad = padding // 2
        right_pad = padding - left_pad
        
        lines = [
            f"{color}╔{'═' * width}╗",
            f"║{' ' * left_pad}{title_with_spaces}{' ' * right_pad}║",
            f"╚{'═' * width}╝{Colors.RESET}"
        ]
        return "\n".join(lines)
    
    @staticmethod
    def draw_separator(width: int = BOX_WIDTH, color: str = Colors.SYSTEM) -> str:
        """Draw a horizontal separator"""
        return f"{color}{'═' * width}{Colors.RESET}"


# ============================================================================
# UI Formatter - Handles all display and color logic
# ============================================================================

class UIFormatter:
    """Handles all UI formatting and display logic"""
    
    @staticmethod
    def format_size(size: int) -> str:
        """Format file size in human-readable format"""
        for unit in FILE_SIZE_UNITS:
            if size < FILE_SIZE_DIVISOR:
                return f"{size:.1f}{unit}"
            size /= FILE_SIZE_DIVISOR
        return f"{size:.1f}TB"
    
    @staticmethod
    def show_diff(old_content: str, new_content: str, filename: str) -> str:
        """Generate and format a unified diff between old and new content"""
        old_lines = old_content.splitlines(keepends=True)
        new_lines = new_content.splitlines(keepends=True)
        
        diff = difflib.unified_diff(
            old_lines,
            new_lines,
            fromfile=f"a/{filename}",
            tofile=f"b/{filename}",
            lineterm=''
        )
        
        colored_diff = []
        for line in diff:
            line = line.rstrip()
            if line.startswith('---') or line.startswith('+++'):
                colored_diff.append(colored(line, Colors.DIFF_INFO))
            elif line.startswith('@@'):
                colored_diff.append(colored(line, Colors.DIFF_INFO))
            elif line.startswith('+'):
                colored_diff.append(colored(line, Colors.DIFF_ADD))
            elif line.startswith('-'):
                colored_diff.append(colored(line, Colors.DIFF_DEL))
            else:
                colored_diff.append(line)
        
        return '\n'.join(colored_diff)
    
    @staticmethod
    def print_welcome(show_thinking: bool, stream_output: bool):
        """Print welcome message with available commands"""
        readline_status = "ENABLED" if READLINE_AVAILABLE else "DISABLED"
        print(colored("╔══════════════════════════════════════════════════════╗", Colors.SYSTEM))
        print(colored("║  Coding Assistant with llama.cpp                     ║", Colors.SYSTEM))
        print(colored("║  Commands:                                          ║", Colors.SYSTEM))
        print(colored("║    exit/quit  - End the session                     ║", Colors.SYSTEM))
        print(colored("║    clear      - Clear conversation history          ║", Colors.SYSTEM))
        print(colored("║    history    - Show command history                ║", Colors.SYSTEM))
        print(colored("║    !<number>  - Rerun command (e.g., !1, !2)        ║", Colors.SYSTEM))
        print(colored("║    stats      - Show API usage statistics           ║", Colors.SYSTEM))
        print(colored("║                                                      ║", Colors.SYSTEM))
        print(colored(f"║  SHOW_THINKING: {'ON ' if show_thinking else 'OFF'}                              ║", Colors.SYSTEM))
        print(colored(f"║  STREAM_OUTPUT: {'ON ' if stream_output else 'OFF'}                              ║", Colors.SYSTEM))
        print(colored(f"║  READLINE:      {readline_status:<7}                         ║", Colors.SYSTEM))
        if READLINE_AVAILABLE:
            print(colored("║    ↑/↓        - Navigate input history              ║", Colors.SYSTEM))
            print(colored("║    ←/→        - Move cursor                          ║", Colors.SYSTEM))
            print(colored("║    Home/End   - Jump to start/end of line           ║", Colors.SYSTEM))
            print(colored("║    Ctrl+←/→   - Jump by word                        ║", Colors.SYSTEM))
        print(colored("╚══════════════════════════════════════════════════════╝", Colors.SYSTEM))
        print()
    
    @staticmethod
    def print_tool_header(tool_name: str, arguments: Dict[str, Any], preview_diff: Optional[str] = None):
        """Display tool call header with arguments"""
        print("\n" + BoxDrawer.draw_box("Tool Call", color=Colors.TOOL))
        print(colored(f"Tool: {tool_name}", Colors.TOOL))
        print(colored("Arguments:", Colors.TOOL))
        
        for key, value in arguments.items():
            display_value = str(value)
            if len(display_value) > MAX_DISPLAY_VALUE_LENGTH:
                display_value = display_value[:MAX_DISPLAY_VALUE_LENGTH] + "..."
            print(f"  {key}: {display_value}")
        
        if preview_diff:
            print(colored("\n═══ Diff Preview ═══", Colors.DIFF_INFO))
            print(preview_diff)
            print(colored("═══ End of Diff ═══", Colors.DIFF_INFO))
    
    @staticmethod
    def print_tool_confirmation(tool_name: str, arguments: Dict[str, Any], preview_diff: Optional[str] = None) -> bool:
        """Display tool confirmation prompt and get user response"""
        print("\n" + BoxDrawer.draw_box("Tool Call Confirmation Required", width=45, color=Colors.TOOL))
        print(colored(f"Tool: {tool_name}", Colors.TOOL))
        print(colored("Arguments:", Colors.TOOL))
        
        for key, value in arguments.items():
            display_value = str(value)
            if len(display_value) > MAX_DISPLAY_VALUE_LENGTH:
                display_value = display_value[:MAX_DISPLAY_VALUE_LENGTH] + "..."
            print(f"  {key}: {display_value}")
        
        if preview_diff:
            print(colored("\n═══ Diff Preview ═══", Colors.DIFF_INFO))
            print(preview_diff)
            print(colored("═══ End of Diff ═══", Colors.DIFF_INFO))
        
        response = input(colored("\nExecute this tool? (y/N): ", Colors.SYSTEM)).strip().lower()
        return response == 'y'
    
    @staticmethod
    def print_command_history(command_history: List[Dict[str, Any]]):
        """Display the command history"""
        if not command_history:
            UIFormatter.print_system("No commands have been executed yet.")
            return
        
        print("\n" + BoxDrawer.draw_box("Command History", width=55))
        print()
        
        for idx, entry in enumerate(command_history, 1):
            status = colored("✓", Colors.DIFF_ADD) if entry["return_code"] == 0 else colored("✗", Colors.DIFF_DEL)
            print(colored(f"[{idx}]", Colors.SYSTEM) + f" {status} {entry['timestamp']}")
            print(f"    Command: {colored(entry['command'], Colors.TOOL)}")
            print(f"    Return code: {entry['return_code']}\n")
    
    @staticmethod
    def print_stats(stats: Dict[str, Any]):
        """Display API usage statistics"""
        print("\n" + BoxDrawer.draw_box("API Usage Statistics"))
        print(colored(f"Total API Calls:      {stats['total_calls']}", Colors.SYSTEM))
        print(colored(f"Total Tokens:         {stats['total_tokens']:,}", Colors.SYSTEM))
        print(colored(f"Prompt Tokens:        {stats['prompt_tokens']:,}", Colors.SYSTEM))
        print(colored(f"Completion Tokens:    {stats['completion_tokens']:,}", Colors.SYSTEM))
        print(colored(f"Avg Tokens per Call:  {stats['avg_tokens_per_call']:,}", Colors.SYSTEM))
        print()
    
    @staticmethod
    def print_error(message: str):
        """Print error message"""
        print(colored(message, Colors.ERROR))
    
    @staticmethod
    def print_system(message: str):
        """Print system message"""
        print(colored(message, Colors.SYSTEM))
    
    @staticmethod
    def print_tool_result(message: str):
        """Print tool execution result"""
        print(colored(f"Result: {message}", Colors.TOOL))


# ============================================================================
# Tool Executor - Handles all tool execution logic
# ============================================================================

class ToolExecutor:
    """Handles execution of all tool functions"""
    
    def __init__(self, ui_formatter: UIFormatter):
        self.ui = ui_formatter
        self.command_history: List[Dict[str, Any]] = []
    
    def requires_confirmation(self, tool_name: str, arguments: Dict[str, Any]) -> bool:
        """Determine if a tool call requires user confirmation"""
        # list_directory doesn't require confirmation if path is under current directory
        if tool_name == "list_directory":
            path = arguments.get("path", ".")
            if self._is_safe_path(path):
                return False
            return True
        
        # All other tools require confirmation
        return True
    
    def _is_safe_path(self, path: str) -> bool:
        """Check if path is within current working directory"""
        try:
            abs_path = os.path.abspath(path)
            cwd = os.path.abspath(os.getcwd())
            return abs_path.startswith(cwd)
        except Exception:
            return False

    def _read_file_safe(self, path: str) -> Optional[str]:
        """Safely read file content, return None if file doesn't exist or can't be read"""
        try:
            if os.path.exists(path):
                with open(path, 'r', encoding='utf-8') as f:
                    return f.read()
        except Exception:
            pass
        return None

    def _calculate_append_content(self, old_content: str, new_content: str, newline_before: bool) -> str:
        """Calculate content to append with proper newline handling"""
        if newline_before and old_content and not old_content.endswith("\n"):
            return "\n" + new_content
        return new_content
    
    def _should_skip_hidden(self, name: str, include_hidden: bool) -> bool:
        """Check if file/directory should be skipped due to hidden status"""
        return not include_hidden and name.startswith('.')
    
    def _get_depth(self, path: str, base: str) -> int:
        """Calculate directory depth relative to base"""
        rel_path = os.path.relpath(path, base)
        if rel_path == '.':
            return 0
        return rel_path.count(os.sep) + 1
    
    def _format_file_entry(self, path: str, name: str) -> Dict[str, str]:
        """Format file information for display"""
        try:
            stat = os.stat(path)
            is_dir = os.path.isdir(path)
            
            return {
                'type': "DIR" if is_dir else "FILE",
                'size': "-" if is_dir else self.ui.format_size(stat.st_size),
                'modified': datetime.fromtimestamp(stat.st_mtime).strftime("%Y-%m-%d %H:%M:%S"),
                'name': name
            }
        except (OSError, PermissionError):
            return {
                'type': '???',
                'size': '???',
                'modified': '???',
                'name': f"{name} (access denied)"
            }
    
    def execute(self, tool_name: str, arguments: Dict[str, Any]) -> str:
        """Execute a tool function and return the result"""
        try:
            if tool_name == "list_directory":
                return self._list_directory(arguments)
            elif tool_name == "search_files":
                return self._search_files(arguments)
            elif tool_name == "find_files":
                return self._find_files(arguments)
            elif tool_name == "create_directory":
                return self._create_directory(arguments)
            elif tool_name == "read_file":
                return self._read_file(arguments)
            elif tool_name == "write_file":
                return self._write_file(arguments)
            elif tool_name == "append_file":
                return self._append_file(arguments)
            elif tool_name == "edit_file":
                return self._edit_file(arguments)
            elif tool_name == "run_command":
                return self._run_command(arguments)
            else:
                return f"Error: Unknown tool '{tool_name}'"
        except Exception as e:
            return f"Error executing tool: {str(e)}"
    
    def get_preview_diff(self, tool_name: str, arguments: Dict[str, Any]) -> Optional[str]:
        """Generate a diff preview for file modification operations"""
        try:
            path = arguments.get("path")
            if not path:
                return None

            old_content = self._read_file_safe(path)
            if old_content is None:
                return None

            if tool_name == "edit_file":
                old_text = arguments.get("old_text")
                new_text = arguments.get("new_text")

                if old_text in old_content:
                    new_content = old_content.replace(old_text, new_text)
                    return self.ui.show_diff(old_content, new_content, os.path.basename(path))

            elif tool_name == "write_file":
                new_content = arguments.get("content", "")
                return self.ui.show_diff(old_content, new_content, os.path.basename(path))

            elif tool_name == "append_file":
                content = arguments.get("content", "")
                newline_before = arguments.get("newline_before", True)

                append_content = self._calculate_append_content(old_content, content, newline_before)
                new_content = old_content + append_content
                return self.ui.show_diff(old_content, new_content, os.path.basename(path))

        except Exception:
            pass

        return None
    
    def _list_directory(self, args: Dict[str, Any]) -> str:
        """List files and directories"""
        path = args.get("path", ".")
        show_hidden = args.get("show_hidden", False)
        
        if not os.path.exists(path):
            return f"Error: Path '{path}' does not exist"
        
        if not os.path.isdir(path):
            return f"Error: '{path}' is not a directory"
        
        try:
            items = os.listdir(path)
        except PermissionError:
            return f"Error: Permission denied to access '{path}'"
        
        if not show_hidden:
            items = [item for item in items if not self._should_skip_hidden(item, show_hidden)]
        
        items.sort(key=lambda x: (not os.path.isdir(os.path.join(path, x)), x.lower()))
        
        output = [f"Contents of '{os.path.abspath(path)}':\n"]
        output.append(f"{'Type':<6} {'Size':<10} {'Modified':<20} {'Name'}")
        output.append("-" * 70)
        
        for item in items:
            full_path = os.path.join(path, item)
            entry = self._format_file_entry(full_path, item)
            output.append(f"{entry['type']:<6} {entry['size']:<10} {entry['modified']:<20} {entry['name']}")
        
        if len(items) == 0:
            output.append("(empty directory)")
        else:
            dir_count = sum(1 for item in items if os.path.isdir(os.path.join(path, item)))
            file_count = len(items) - dir_count
            output.append(f"\nTotal: {dir_count} directories, {file_count} files")
        
        return "\n".join(output)
    
    def _search_files(self, args: Dict[str, Any]) -> str:
        """Search for text patterns across files"""
        search_pattern = args["pattern"]
        file_pattern = args.get("file_pattern", "*")
        use_regex = args.get("regex", False)
        case_sensitive = args.get("case_sensitive", True)
        max_results = args.get("max_results", DEFAULT_MAX_SEARCH_RESULTS)
        include_hidden = args.get("include_hidden", False)
        context_lines = args.get("context_lines", DEFAULT_CONTEXT_LINES)
        
        matches = []
        total_matches = 0
        start_path = os.getcwd()
        
        if use_regex:
            try:
                flags = 0 if case_sensitive else re.IGNORECASE
                compiled_pattern = re.compile(search_pattern, flags)
            except re.error as e:
                return f"Invalid regex pattern: {e}"
        else:
            compiled_pattern = None
        
        def match_line(line):
            if use_regex:
                return compiled_pattern.search(line)
            else:
                if case_sensitive:
                    return search_pattern in line
                else:
                    return search_pattern.lower() in line.lower()
        
        for root, dirs, files in os.walk(start_path):
            if not include_hidden:
                dirs[:] = [d for d in dirs if not self._should_skip_hidden(d, include_hidden)]
            
            for filename in files:
                if self._should_skip_hidden(filename, include_hidden):
                    continue
                
                if not fnmatch.fnmatch(filename, file_pattern):
                    continue
                
                full_path = os.path.join(root, filename)
                rel_path = os.path.relpath(full_path, start_path)
                
                try:
                    with open(full_path, 'r', encoding='utf-8', errors='ignore') as f:
                        lines = f.readlines()
                    
                    for line_num, line in enumerate(lines, 1):
                        if total_matches >= max_results:
                            break
                        
                        if match_line(line):
                            context_before = []
                            context_after = []
                            
                            if context_lines > 0:
                                start_idx = max(0, line_num - 1 - context_lines)
                                end_idx = min(len(lines), line_num + context_lines)
                                
                                context_before = lines[start_idx:line_num - 1]
                                context_after = lines[line_num:end_idx]
                            
                            matches.append({
                                'file': rel_path,
                                'line_num': line_num,
                                'line': line.rstrip('\n'),
                                'context_before': [l.rstrip('\n') for l in context_before],
                                'context_after': [l.rstrip('\n') for l in context_after]
                            })
                            total_matches += 1
                
                except (OSError, PermissionError, UnicodeDecodeError):
                    continue
                
                if total_matches >= max_results:
                    break
            
            if total_matches >= max_results:
                break
        
        if not matches:
            return f"No matches found for pattern '{search_pattern}'"
        
        output = [f"Found {len(matches)} match(es) for '{search_pattern}'"]
        if len(matches) >= max_results:
            output[0] += f" (limited to {max_results} results)"
        output.append("")
        
        current_file = None
        for match in matches:
            if match['file'] != current_file:
                if current_file is not None:
                    output.append("")
                output.append(colored(match['file'], Colors.DIFF_INFO))
                current_file = match['file']
            
            if match['context_before']:
                for ctx_line in match['context_before']:
                    output.append(colored(f"  {ctx_line}", Colors.SYSTEM))
            
            output.append(colored(f"{match['line_num']:>4}: {match['line']}", Colors.DIFF_ADD))
            
            if match['context_after']:
                for ctx_line in match['context_after']:
                    output.append(colored(f"  {ctx_line}", Colors.SYSTEM))
        
        return "\n".join(output)
    
    def _find_files(self, args: Dict[str, Any]) -> str:
        """Find files by name pattern"""
        pattern = args["pattern"]
        max_depth = args.get("max_depth", None)
        include_hidden = args.get("include_hidden", False)
        
        matches = []
        start_path = os.getcwd()
        
        for root, dirs, files in os.walk(start_path):
            if not include_hidden:
                dirs[:] = [d for d in dirs if not self._should_skip_hidden(d, include_hidden)]
            
            current_depth = self._get_depth(root, start_path)
            if max_depth is not None and current_depth >= max_depth:
                dirs[:] = []
            
            for filename in files:
                if self._should_skip_hidden(filename, include_hidden):
                    continue
                
                if fnmatch.fnmatch(filename, pattern):
                    full_path = os.path.join(root, filename)
                    rel_path = os.path.relpath(full_path, start_path)
                    
                    try:
                        stat = os.stat(full_path)
                        size = self.ui.format_size(stat.st_size)
                        mtime = datetime.fromtimestamp(stat.st_mtime).strftime("%Y-%m-%d %H:%M:%S")
                        matches.append({
                            'path': rel_path,
                            'size': size,
                            'modified': mtime
                        })
                    except (OSError, PermissionError):
                        matches.append({
                            'path': rel_path,
                            'size': '???',
                            'modified': '???'
                        })
        
        if not matches:
            return f"No files found matching pattern '{pattern}'"
        
        output = [f"Found {len(matches)} file(s) matching '{pattern}':\n"]
        output.append(f"{'Size':<10} {'Modified':<20} {'Path'}")
        output.append("-" * 70)
        
        for match in matches:
            output.append(f"{match['size']:<10} {match['modified']:<20} {match['path']}")
        
        return "\n".join(output)
    
    def _create_directory(self, args: Dict[str, Any]) -> str:
        """Create a new directory"""
        path = args["path"]
        parents = args.get("parents", True)
        
        if os.path.exists(path):
            if os.path.isdir(path):
                return f"Directory '{path}' already exists"
            else:
                return f"Error: '{path}' exists but is not a directory"
        
        try:
            if parents:
                os.makedirs(path, exist_ok=True)
                parts = []
                current = path
                while current and current != os.path.dirname(current):
                    if not os.path.exists(os.path.dirname(current)):
                        parts.insert(0, current)
                    current = os.path.dirname(current)
                
                if parts:
                    created_msg = "Created directories:\n  " + "\n  ".join(parts)
                else:
                    created_msg = f"Created directory: {path}"
            else:
                os.mkdir(path)
                created_msg = f"Created directory: {path}"
            
            abs_path = os.path.abspath(path)
            return f"{created_msg}\n\nFull path: {abs_path}"
        
        except PermissionError:
            return f"Error: Permission denied to create '{path}'"
        except FileNotFoundError:
            return f"Error: Parent directory does not exist. Use 'parents: true' to create parent directories."
        except Exception as e:
            return f"Error creating directory: {str(e)}"
    
    def _read_file(self, args: Dict[str, Any]) -> str:
        """Read file contents"""
        path = args["path"]
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
        return f"File contents of '{path}':\n{content}"
    
    def _write_file(self, args: Dict[str, Any]) -> str:
        """Write content to file"""
        path = args["path"]
        content = args["content"]

        old_content = self._read_file_safe(path)

        if old_content is not None:
            try:
                result = f"Successfully overwrote '{path}'\n\nChanges made:\n"
                result += self.ui.show_diff(old_content, content, os.path.basename(path))
            except Exception as e:
                result = f"Successfully overwrote '{path}' (could not show diff: {e})"
        else:
            result = f"Successfully created new file '{path}' ({len(content)} characters)"

        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)

        return result
    
    def _append_file(self, args: Dict[str, Any]) -> str:
        """Append content to file"""
        path = args["path"]
        content = args["content"]
        newline_before = args.get("newline_before", True)

        old_content = self._read_file_safe(path)

        if old_content is not None:
            append_content = self._calculate_append_content(old_content, content, newline_before)

            with open(path, 'a', encoding='utf-8') as f:
                f.write(append_content)
            
            lines_added = content.count('\n') + (1 if content and not content.endswith('\n') else 0)
            result = f"Successfully appended to '{path}' ({lines_added} line(s) added)\n\nAppended content:\n"
            result += colored("", Colors.DIFF_ADD)
            
            for line in content.splitlines():
                result += f"+{line}\n"
            result += Colors.RESET
            
            old_lines = old_content.splitlines()
            if len(old_lines) > DIFF_CONTEXT_LINES:
                result += colored(f"\nContext (last {DIFF_CONTEXT_LINES} lines of original file):", Colors.DIFF_INFO) + "\n"
                for line in old_lines[-DIFF_CONTEXT_LINES:]:
                    result += f" {line}\n"
        else:
            with open(path, 'w', encoding='utf-8') as f:
                f.write(content)
            result = f"Created new file '{path}' with appended content ({len(content)} characters)"
        
        return result
    
    def _edit_file(self, args: Dict[str, Any]) -> str:
        """Edit file by replacing text"""
        path = args["path"]
        old_text = args["old_text"]
        new_text = args["new_text"]
        
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        if old_text not in content:
            return f"Error: Text to replace not found in '{path}'"
        
        new_content = content.replace(old_text, new_text)
        
        diff_output = self.ui.show_diff(content, new_content, os.path.basename(path))
        
        with open(path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        
        occurrences = content.count(old_text)
        return f"Successfully edited '{path}' ({occurrences} occurrence(s) replaced)\n\nChanges made:\n{diff_output}"
    
    def _run_command(self, args: Dict[str, Any]) -> str:
        """Execute a shell command"""
        command = args["command"]
        
        history_entry = {
            "command": command,
            "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        }
        
        result = subprocess.run(
            command,
            shell=True,
            capture_output=True,
            text=True,
            timeout=API_TIMEOUT
        )
        
        output = []
        if result.stdout:
            output.append(f"STDOUT:\n{result.stdout}")
        if result.stderr:
            output.append(f"STDERR:\n{result.stderr}")
        output.append(f"Return code: {result.returncode}")
        
        result_str = "\n".join(output)
        
        history_entry["result"] = result_str
        history_entry["return_code"] = result.returncode
        self.command_history.append(history_entry)
        
        return result_str


# ============================================================================
# Conversation Manager - Manages conversation state and history
# ============================================================================

class ConversationManager:
    """Manages conversation state and history"""
    
    def __init__(self):
        self.conversation: List[Dict[str, Any]] = []
        self.system_prompt = """You are a helpful coding assistant. You can read, write, and edit files, as well as run shell commands.
When the user asks you to perform operations, use the available tools to help them.
Be concise and clear in your responses."""
    
    def add_user_message(self, content: str):
        """Add a user message to the conversation"""
        self.conversation.append({"role": "user", "content": content})
    
    def add_assistant_message(self, message: Dict[str, Any]):
        """Add an assistant message to the conversation"""
        self.conversation.append(message)
    
    def add_tool_response(self, tool_call_id: str, content: str):
        """Add a tool response to the conversation"""
        self.conversation.append({
            "role": "tool",
            "tool_call_id": tool_call_id,
            "content": content
        })
    
    def get_messages_with_system(self) -> List[Dict[str, Any]]:
        """Get conversation with system prompt prepended"""
        return [{"role": "system", "content": self.system_prompt}] + self.conversation
    
    def clear(self):
        """Clear the conversation history"""
        self.conversation = []
    
    def get_history(self) -> List[Dict[str, Any]]:
        """Get the conversation history"""
        return self.conversation.copy()


# ============================================================================
# Input Handler - Manages readline and input history
# ============================================================================

# ============================================================================
# Input Handler - Manages readline and input history
# ============================================================================

# Readline key bindings configuration
READLINE_BINDINGS = {
    'tab': 'complete',
    r'"\e[A"': 'previous-history',
    r'"\e[B"': 'next-history',
    r'"\e[C"': 'forward-char',
    r'"\e[D"': 'backward-char',
    r'"\e[H"': 'beginning-of-line',
    r'"\e[F"': 'end-of-line',
    r'"\e[1~"': 'beginning-of-line',
    r'"\e[4~"': 'end-of-line',
    'Control-a': 'beginning-of-line',
    'Control-e': 'end-of-line',
    r'"\e[1;5C"': 'forward-word',
    r'"\e[1;5D"': 'backward-word',
}

class InputHandler:
    """Manages user input with readline support"""
    
    def __init__(self):
        self.history_file = None
        self._setup_readline()
    
    def _setup_readline(self):
        """Configure readline for enhanced input editing"""
        if not READLINE_AVAILABLE:
            return
        
        # Apply all key bindings
        for key, action in READLINE_BINDINGS.items():
            readline.parse_and_bind(f'{key}: {action}')
        
        history_file = os.path.expanduser('~/.coding_assistant_history')
        self.history_file = history_file
        
        if os.path.exists(history_file):
            try:
                readline.read_history_file(history_file)
            except Exception:
                pass
        
        readline.set_history_length(MAX_HISTORY_SIZE)
    
    def save_to_history(self, user_input: str):
        """Save user input to readline history"""
        if not READLINE_AVAILABLE or not user_input.strip():
            return
        
        readline.add_history(user_input)
        
        try:
            readline.write_history_file(self.history_file)
        except Exception:
            pass
    
    def get_input(self, prompt: str) -> str:
        """Get user input with the given prompt"""
        return input(prompt).strip()


# ============================================================================
# API Client - Handles communication with llama.cpp server
# ============================================================================

class APIClient:
    """Handles API communication with llama.cpp server"""
    
    def __init__(self, server_url: str, ui_formatter: UIFormatter, show_thinking: bool, stream_output: bool):
        self.server_url = server_url
        self.ui = ui_formatter
        self.show_thinking = show_thinking
        self.stream_output = stream_output
        
        # Token usage tracking
        self.total_tokens = 0
        self.prompt_tokens = 0
        self.completion_tokens = 0
        self.total_calls = 0
        
        try:
            self.client = OpenAI(
                base_url=f"{server_url}/v1",
                api_key="dummy"
            )
            self.ui.print_system(f"Connected to llama.cpp server at {server_url}")
        except ImportError:
            self.ui.print_error("Error: openai library not found.")
            print("Install with: pip install openai")
            sys.exit(1)
    
    def call(self, messages: List[Dict[str, Any]], tools: List[Dict[str, Any]]) -> Optional[Dict[str, Any]]:
        """Call the llama.cpp server API"""
        try:
            tools_formatted = [{"type": "function", "function": tool["function"]} for tool in tools]
            
            if self.stream_output:
                response = self._call_streaming(messages, tools_formatted)
            else:
                response = self._call_non_streaming(messages, tools_formatted)
            
            # Track usage if available
            if response:
                self._update_usage_stats(response)
            
            return response
        
        except Exception as e:
            self.ui.print_error(f"API Error: {e}")
            return None
    
    def _update_usage_stats(self, response: Dict[str, Any]):
        """Update token usage statistics from API response"""
        self.total_calls += 1
        
        # Check if usage info is present in response
        usage = response.get('usage')
        if usage:
            self.total_tokens += usage.get('total_tokens', 0)
            self.prompt_tokens += usage.get('prompt_tokens', 0)
            self.completion_tokens += usage.get('completion_tokens', 0)
    
    def get_stats(self) -> Dict[str, Any]:
        """Get API usage statistics"""
        stats = {
            'total_calls': self.total_calls,
            'total_tokens': self.total_tokens,
            'prompt_tokens': self.prompt_tokens,
            'completion_tokens': self.completion_tokens,
        }
        
        if self.total_calls > 0:
            stats['avg_tokens_per_call'] = self.total_tokens // self.total_calls
        else:
            stats['avg_tokens_per_call'] = 0
        
        return stats
    
    def reset_stats(self):
        """Reset usage statistics"""
        self.total_tokens = 0
        self.prompt_tokens = 0
        self.completion_tokens = 0
        self.total_calls = 0
    
    def _call_streaming(self, messages: List[Dict[str, Any]], tools: List[Dict[str, Any]]) -> Optional[Dict[str, Any]]:
        """Call API with streaming enabled"""
        stream = self.client.chat.completions.create(
            model=DEFAULT_MODEL,
            messages=messages,
            tools=tools,
            temperature=DEFAULT_TEMPERATURE,
            max_tokens=DEFAULT_MAX_TOKENS,
            stream=True,
            stream_options={"include_usage": True}  # Request usage info in stream
        )
        
        full_content = ""
        tool_calls_dict = {}
        role = "assistant"
        usage_info = None
        
        if self.show_thinking:
            print(f"{Colors.THINKING}", end="", flush=True)
        else:
            print(f"{Colors.ASSISTANT}", end="", flush=True)
        
        for chunk in stream:
            if not chunk.choices:
                # Check for usage information in chunks without choices
                if hasattr(chunk, 'usage') and chunk.usage:
                    usage_info = {
                        'total_tokens': chunk.usage.total_tokens,
                        'prompt_tokens': chunk.usage.prompt_tokens,
                        'completion_tokens': chunk.usage.completion_tokens
                    }
                continue
            
            delta = chunk.choices[0].delta
            
            if delta.content:
                print(delta.content, end="", flush=True)
                full_content += delta.content
            
            if delta.role:
                role = delta.role
            
            if delta.tool_calls:
                for tool_call in delta.tool_calls:
                    idx = tool_call.index
                    if idx not in tool_calls_dict:
                        tool_calls_dict[idx] = {
                            "id": "",
                            "type": "function",
                            "function": {"name": "", "arguments": ""}
                        }
                    
                    if tool_call.id:
                        tool_calls_dict[idx]["id"] = tool_call.id
                    
                    if tool_call.function:
                        if tool_call.function.name:
                            tool_calls_dict[idx]["function"]["name"] = tool_call.function.name
                        if tool_call.function.arguments:
                            tool_calls_dict[idx]["function"]["arguments"] += tool_call.function.arguments
        
        if full_content:
            print(f"{Colors.RESET}")
        
        message_dict = {
            "role": role,
            "content": full_content if full_content else None
        }
        
        if tool_calls_dict:
            message_dict["tool_calls"] = [tool_calls_dict[i] for i in sorted(tool_calls_dict.keys())]
        
        response = {"choices": [{"message": message_dict}]}
        
        # Add usage info if available
        if usage_info:
            response['usage'] = usage_info
        
        return response
    
    def _call_non_streaming(self, messages: List[Dict[str, Any]], tools: List[Dict[str, Any]]) -> Optional[Dict[str, Any]]:
        """Call API without streaming"""
        response = self.client.chat.completions.create(
            model=DEFAULT_MODEL,
            messages=messages,
            tools=tools,
            temperature=DEFAULT_TEMPERATURE,
            max_tokens=DEFAULT_MAX_TOKENS
        )
        
        choice = response.choices[0]
        message_dict = {
            "role": choice.message.role,
            "content": choice.message.content
        }
        
        if choice.message.tool_calls:
            message_dict["tool_calls"] = []
            for tool_call in choice.message.tool_calls:
                message_dict["tool_calls"].append({
                    "id": tool_call.id,
                    "type": "function",
                    "function": {
                        "name": tool_call.function.name,
                        "arguments": tool_call.function.arguments
                    }
                })
        
        result = {"choices": [{"message": message_dict}]}
        
        # Add usage info if available
        if hasattr(response, 'usage') and response.usage:
            result['usage'] = {
                'total_tokens': response.usage.total_tokens,
                'prompt_tokens': response.usage.prompt_tokens,
                'completion_tokens': response.usage.completion_tokens
            }
        
        return result


# ============================================================================
# Tool Definitions
# ============================================================================

TOOLS = [
    {
        "type": "function",
        "function": {
            "name": "list_directory",
            "description": "List files and directories in a given path. Shows file sizes, types, and modification times.",
            "parameters": {
                "type": "object",
                "properties": {
                    "path": {
                        "type": "string",
                        "description": "Path to the directory to list. Defaults to current directory if not specified."
                    },
                    "show_hidden": {
                        "type": "boolean",
                        "description": "Whether to show hidden files (starting with .)",
                        "default": False
                    }
                },
                "required": []
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "search_files",
            "description": "Search for text patterns across multiple files (like grep). Searches recursively from current directory.",
            "parameters": {
                "type": "object",
                "properties": {
                    "pattern": {
                        "type": "string",
                        "description": "Text pattern to search for. Can be a literal string or regex pattern."
                    },
                    "file_pattern": {
                        "type": "string",
                        "description": "File name pattern to limit search (e.g., '*.py', '*.txt'). Default: '*' (all files)",
                        "default": "*"
                    },
                    "regex": {
                        "type": "boolean",
                        "description": "Treat pattern as regex instead of literal text",
                        "default": False
                    },
                    "case_sensitive": {
                        "type": "boolean",
                        "description": "Whether search should be case-sensitive",
                        "default": True
                    },
                    "max_results": {
                        "type": "integer",
                        "description": "Maximum number of matches to return (default: 100)",
                        "default": 100
                    },
                    "include_hidden": {
                        "type": "boolean",
                        "description": "Whether to search in hidden files/directories",
                        "default": False
                    },
                    "context_lines": {
                        "type": "integer",
                        "description": "Number of lines of context to show before/after match (default: 0)",
                        "default": 0
                    }
                },
                "required": ["pattern"]
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "find_files",
            "description": "Find files by name pattern under the current directory. Supports wildcards like *.py, test_*.txt, etc.",
            "parameters": {
                "type": "object",
                "properties": {
                    "pattern": {
                        "type": "string",
                        "description": "File name pattern to search for. Supports wildcards: * (any chars), ? (single char). Examples: '*.py', 'test_*.txt', 'config.json'"
                    },
                    "max_depth": {
                        "type": "integer",
                        "description": "Maximum directory depth to search (default: unlimited). 1 = current dir only, 2 = one level deep, etc.",
                        "default": None
                    },
                    "include_hidden": {
                        "type": "boolean",
                        "description": "Whether to include hidden files and directories (starting with .)",
                        "default": False
                    }
                },
                "required": ["pattern"]
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "create_directory",
            "description": "Create a new directory or nested directories. Can create parent directories if they don't exist.",
            "parameters": {
                "type": "object",
                "properties": {
                    "path": {
                        "type": "string",
                        "description": "Path to the directory to create. Can be nested (e.g., 'project/src/utils')"
                    },
                    "parents": {
                        "type": "boolean",
                        "description": "Create parent directories if they don't exist (like mkdir -p)",
                        "default": True
                    }
                },
                "required": ["path"]
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "read_file",
            "description": "Read the contents of a file",
            "parameters": {
                "type": "object",
                "properties": {
                    "path": {
                        "type": "string",
                        "description": "Path to the file to read"
                    }
                },
                "required": ["path"]
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "write_file",
            "description": "Write content to a file (creates or overwrites)",
            "parameters": {
                "type": "object",
                "properties": {
                    "path": {
                        "type": "string",
                        "description": "Path to the file to write"
                    },
                    "content": {
                        "type": "string",
                        "description": "Content to write to the file"
                    }
                },
                "required": ["path", "content"]
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "append_file",
            "description": "Append content to the end of an existing file, or create a new file if it doesn't exist",
            "parameters": {
                "type": "object",
                "properties": {
                    "path": {
                        "type": "string",
                        "description": "Path to the file to append to"
                    },
                    "content": {
                        "type": "string",
                        "description": "Content to append to the file"
                    },
                    "newline_before": {
                        "type": "boolean",
                        "description": "Add a newline before the appended content",
                        "default": True
                    }
                },
                "required": ["path", "content"]
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "edit_file",
            "description": "Edit a file by replacing old text with new text",
            "parameters": {
                "type": "object",
                "properties": {
                    "path": {
                        "type": "string",
                        "description": "Path to the file to edit"
                    },
                    "old_text": {
                        "type": "string",
                        "description": "Text to find and replace"
                    },
                    "new_text": {
                        "type": "string",
                        "description": "Text to replace with"
                    }
                },
                "required": ["path", "old_text", "new_text"]
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "run_command",
            "description": "Execute a shell command and return its output",
            "parameters": {
                "type": "object",
                "properties": {
                    "command": {
                        "type": "string",
                        "description": "Shell command to execute"
                    }
                },
                "required": ["command"]
            }
        }
    }
]


# ============================================================================
# Main Coding Assistant - Orchestrates all components
# ============================================================================

class CodingAssistant:
    """Main coding assistant that orchestrates all components"""
    
    def __init__(self, server_url: str = "http://127.0.0.1:8033", 
                 show_thinking: bool = True, stream_output: bool = True):
        self.show_thinking = show_thinking
        self.stream_output = stream_output
        
        # Initialize components
        self.ui = UIFormatter()
        self.conversation = ConversationManager()
        self.tool_executor = ToolExecutor(self.ui)
        self.input_handler = InputHandler()
        self.api_client = APIClient(server_url, self.ui, show_thinking, stream_output)
    
    def handle_special_commands(self, user_input: str) -> Tuple[bool, bool]:
        """Handle special built-in commands. Returns (handled, should_exit)"""
        cmd = user_input.lower().strip()
        
        if cmd in ['exit', 'quit']:
            self.ui.print_system("Goodbye!")
            return True, True
        
        if cmd == 'clear':
            self.conversation.clear()
            self.ui.print_system("Conversation history cleared")
            return True, False
        
        if cmd == 'history':
            self.ui.print_command_history(self.tool_executor.command_history)
            return True, False
        
        if cmd == 'stats':
            stats = self.api_client.get_stats()
            self.ui.print_stats(stats)
            return True, False
        
        if cmd == 'resetstats':
            self.api_client.reset_stats()
            self.ui.print_system("API usage statistics reset")
            return True, False
        
        if cmd.startswith('!') and len(cmd) > 1:
            try:
                index = int(cmd[1:])
                self.rerun_command(index)
            except ValueError:
                self.ui.print_error("Invalid command format. Use !<number> (e.g., !1, !2)")
            return True, False
        
        return False, False
    
    def rerun_command(self, index: int):
        """Rerun a command from history"""
        if not self.tool_executor.command_history:
            self.ui.print_error("No commands in history.")
            return
        
        if index < 1 or index > len(self.tool_executor.command_history):
            self.ui.print_error("Invalid command index. Use 'history' to see available commands.")
            return
        
        entry = self.tool_executor.command_history[index - 1]
        command = entry["command"]
        
        self.ui.print_system("Rerunning command from history:")
        print(f"{Colors.TOOL}{command}{Colors.RESET}\n")
        
        response = input(f"{Colors.SYSTEM}Execute this command? (y/N): {Colors.RESET}").strip().lower()
        if response != 'y':
            self.ui.print_system("Command execution cancelled.")
            return
        
        self.ui.print_system("[Executing...]")
        result_str = self.tool_executor.execute("run_command", {"command": command})
        self.ui.print_tool_result(result_str)
    
    def process_message(self, user_input: str):
        """Process a user message and handle tool calls"""
        self.conversation.add_user_message(user_input)
        
        messages = self.conversation.get_messages_with_system()
        
        max_iterations = 10
        iteration = 0
        
        while iteration < max_iterations:
            iteration += 1
            
            if self.show_thinking and not self.stream_output:
                self.ui.print_system("[Thinking...]")
            
            response = self.api_client.call(messages, TOOLS)
            
            if not response:
                self.ui.print_error("Failed to get response from API")
                return
            
            choice = response.get("choices", [{}])[0]
            message = choice.get("message", {})
            
            tool_calls = message.get("tool_calls", [])
            content = message.get("content", "")
            
            if not tool_calls:
                if content:
                    if not self.stream_output:
                        if self.show_thinking:
                            print(f"{Colors.THINKING}{content}{Colors.RESET}")
                        else:
                            print(f"{Colors.ASSISTANT}{content}{Colors.RESET}")
                    # In streaming mode, content was already displayed
                    
                    self.conversation.add_assistant_message({"role": "assistant", "content": content})
                break
            
            # When there are tool calls, display any thinking content if present
            if content and not self.stream_output:
                if self.show_thinking:
                    print(f"{Colors.THINKING}{content}{Colors.RESET}")
            # In streaming mode, thinking was already displayed
            
            self.conversation.add_assistant_message(message)
            
            for tool_call in tool_calls:
                func = tool_call.get("function", {})
                tool_name = func.get("name")
                arguments = json.loads(func.get("arguments", "{}"))
                tool_id = tool_call.get("id")
                
                # Check if this tool requires confirmation
                needs_confirmation = self.tool_executor.requires_confirmation(tool_name, arguments)
                
                if needs_confirmation:
                    preview_diff = self.tool_executor.get_preview_diff(tool_name, arguments)
                    
                    if not self.ui.print_tool_confirmation(tool_name, arguments, preview_diff):
                        result = "User declined to execute this tool"
                        if self.show_thinking:
                            self.ui.print_system(result)
                        self.conversation.add_tool_response(tool_id, result)
                        continue
                else:
                    # Tool doesn't require confirmation, but still show what's being executed
                    self.ui.print_tool_header(tool_name, arguments)
                
                # Execute the tool
                if self.show_thinking:
                    self.ui.print_system("[Executing...]")
                result = self.tool_executor.execute(tool_name, arguments)
                self.ui.print_tool_result(result)
                
                self.conversation.add_tool_response(tool_id, result)
            
            messages = self.conversation.get_messages_with_system()
    
    def run(self):
        """Main interaction loop"""
        self.ui.print_welcome(self.show_thinking, self.stream_output)
        
        while True:
            try:
                print('───────────────────────────────────────────────────')
                user_input = self.input_handler.get_input(f"› ")
                
                if not user_input:
                    continue
                
                self.input_handler.save_to_history(user_input)
                
                handled, should_exit = self.handle_special_commands(user_input)
                if should_exit:
                    break
                if handled:
                    continue
                
                self.process_message(user_input)
                print()
                
            except KeyboardInterrupt:
                self.ui.print_system("\nInterrupted. Type 'exit' to quit.")
            except EOFError:
                self.ui.print_system("\nGoodbye!")
                break
            except Exception as e:
                self.ui.print_error(f"Error: {e}")


# ============================================================================
# Main Entry Point
# ============================================================================

def main():
    # Use global configuration constants
    server_url = DEFAULT_SERVER_URL
    
    if len(sys.argv) > 1:
        server_url = sys.argv[1]
    
    print(colored("Starting Coding Assistant...", Colors.SYSTEM))
    print(colored(f"Connecting to llama.cpp server at: {server_url}", Colors.SYSTEM))
    print()
    
    assistant = CodingAssistant(server_url, SHOW_THINKING, STREAM_OUTPUT)
    assistant.run()


if __name__ == "__main__":
    main()
