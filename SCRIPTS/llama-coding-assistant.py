#!/usr/bin/env python3
"""
Interactive Coding Assistant using llama.cpp server via llama-cpp-python
Supports file operations and command execution with user confirmation
"""

import json
import os
import subprocess
import sys
from datetime import datetime
from typing import Optional, Dict, Any, List
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
    print("Warning: readline not available. Arrow key navigation will be limited.")

# ANSI color codes
class Colors:
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

# Configuration
SHOW_THINKING = True  # Set to False to hide model thinking/reasoning output
STREAM_OUTPUT = True  # Set to False to disable streaming and show complete responses at once

# Tool definitions
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

class CodingAssistant:
    def __init__(self, server_url: str = "http://127.0.0.1:8033"):
        """
        Initialize the coding assistant with llama-cpp-python client.
        
        Args:
            server_url: URL of the llama.cpp server (e.g., "http://127.0.0.1:8033")
        """
        self.server_url = server_url
        
        # Initialize llama-cpp-python client pointing to the server
        try:
            # Use the server's OpenAI-compatible API endpoint
            from openai import OpenAI
            self.client = OpenAI(
                base_url=f"{server_url}/v1",
                api_key="dummy"  # llama.cpp server doesn't require a real key
            )
            self.use_openai_client = True
            print(f"{Colors.SYSTEM}Connected to llama.cpp server at {server_url}{Colors.RESET}")
        except ImportError:
            print(f"{Colors.ERROR}Error: openai library not found.{Colors.RESET}")
            print("Install with: pip install openai")
            sys.exit(1)
        
        self.conversation: List[Dict[str, Any]] = []
        self.command_history: List[Dict[str, Any]] = []
        self.system_prompt = """You are a helpful coding assistant. You can read, write, and edit files, as well as run shell commands.
When the user asks you to perform operations, use the available tools to help them.
Be concise and clear in your responses."""
        
        # Setup readline for input history and line editing
        self._setup_readline()
    
    def _setup_readline(self):
        """Configure readline for enhanced input editing"""
        if not READLINE_AVAILABLE:
            return
        
        # Enable tab completion (optional, could add custom completers later)
        readline.parse_and_bind('tab: complete')
        
        # Enable history search with up/down arrows
        readline.parse_and_bind(r'"\e[A": previous-history')  # Up arrow
        readline.parse_and_bind(r'"\e[B": next-history')      # Down arrow
        
        # Enable left/right arrow keys for cursor movement (default behavior)
        readline.parse_and_bind(r'"\e[C": forward-char')      # Right arrow
        readline.parse_and_bind(r'"\e[D": backward-char')     # Left arrow
        
        # Enable Home/End keys
        readline.parse_and_bind(r'"\e[H": beginning-of-line') # Home
        readline.parse_and_bind(r'"\e[F": end-of-line')       # End
        readline.parse_and_bind(r'"\e[1~": beginning-of-line') # Home (alternative)
        readline.parse_and_bind(r'"\e[4~": end-of-line')       # End (alternative)
        
        # Ctrl+A/E for beginning/end (emacs-style, usually default)
        readline.parse_and_bind('Control-a: beginning-of-line')
        readline.parse_and_bind('Control-e: end-of-line')
        
        # Ctrl+left/right for word jumping
        readline.parse_and_bind(r'"\e[1;5C": forward-word')   # Ctrl+Right
        readline.parse_and_bind(r'"\e[1;5D": backward-word')  # Ctrl+Left
        
        # Set history file to persist between sessions
        history_file = os.path.expanduser('~/.coding_assistant_history')
        self.history_file = history_file
        
        # Load previous history if exists
        if os.path.exists(history_file):
            try:
                readline.read_history_file(history_file)
            except Exception as e:
                pass  # Ignore errors reading history
        
        # Set maximum history size
        readline.set_history_length(1000)
    
    def _save_input_to_history(self, user_input: str):
        """Save user input to readline history"""
        if not READLINE_AVAILABLE or not user_input.strip():
            return
        
        # Add to readline history
        readline.add_history(user_input)
        
        # Save to file
        try:
            readline.write_history_file(self.history_file)
        except Exception:
            pass  # Ignore errors writing history
    
    def call_api(self, messages: List[Dict[str, Any]]) -> Optional[Dict[str, Any]]:
        """Call the llama.cpp server using OpenAI-compatible client"""
        try:
            # Convert tools to OpenAI format
            tools_formatted = []
            for tool in TOOLS:
                tools_formatted.append({
                    "type": "function",
                    "function": tool["function"]
                })
            
            if STREAM_OUTPUT:
                # Streaming mode
                stream = self.client.chat.completions.create(
                    model="openai_gpt-oss-20b-MXFP4",
                    messages=messages,
                    tools=tools_formatted,
                    temperature=0.7,
                    max_tokens=2000,
                    stream=True
                )
                
                # Collect streamed response
                full_content = ""
                tool_calls_dict = {}
                role = "assistant"
                
                # Show thinking indicator and start colored output if enabled
                if SHOW_THINKING:
                    print(f"{Colors.THINKING}", end="", flush=True)
                else:
                    print(f"{Colors.ASSISTANT}", end="", flush=True)
                
                for chunk in stream:
                    if not chunk.choices:
                        continue
                    
                    delta = chunk.choices[0].delta
                    
                    # Handle content (thinking/reasoning)
                    if delta.content:
                        print(delta.content, end="", flush=True)
                        full_content += delta.content
                    
                    # Handle role
                    if delta.role:
                        role = delta.role
                    
                    # Handle tool calls
                    if delta.tool_calls:
                        for tool_call in delta.tool_calls:
                            idx = tool_call.index
                            if idx not in tool_calls_dict:
                                tool_calls_dict[idx] = {
                                    "id": "",
                                    "type": "function",
                                    "function": {
                                        "name": "",
                                        "arguments": ""
                                    }
                                }
                            
                            if tool_call.id:
                                tool_calls_dict[idx]["id"] = tool_call.id
                            
                            if tool_call.function:
                                if tool_call.function.name:
                                    tool_calls_dict[idx]["function"]["name"] = tool_call.function.name
                                if tool_call.function.arguments:
                                    tool_calls_dict[idx]["function"]["arguments"] += tool_call.function.arguments
                
                # End colored output with newline if we displayed content
                if full_content:
                    print(f"{Colors.RESET}")
                
                # Build response in expected format
                message_dict = {
                    "role": role,
                    "content": full_content if full_content else None
                }
                
                if tool_calls_dict:
                    message_dict["tool_calls"] = [tool_calls_dict[i] for i in sorted(tool_calls_dict.keys())]
                
                return {
                    "choices": [{
                        "message": message_dict
                    }]
                }
            
            else:
                # Non-streaming mode (original behavior)
                response = self.client.chat.completions.create(
                    model="openai_gpt-oss-20b-MXFP4",
                    messages=messages,
                    tools=tools_formatted,
                    temperature=0.7,
                    max_tokens=2000
                )
                
                # Convert response to dict format similar to requests
                choice = response.choices[0]
                message_dict = {
                    "role": choice.message.role,
                    "content": choice.message.content
                }
                
                # Handle tool calls if present
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
                
                return {
                    "choices": [{
                        "message": message_dict
                    }]
                }
            
        except Exception as e:
            print(f"{Colors.ERROR}API Error: {e}{Colors.RESET}")
            return None
    
    def confirm_tool(self, tool_name: str, arguments: Dict[str, Any]) -> bool:
        """Ask user for confirmation before executing a tool"""
        print(f"\n{Colors.TOOL}╔══════════════════════════════════════╗")
        print(f"║  Tool Call Confirmation Required     ║")
        print(f"╚══════════════════════════════════════╝{Colors.RESET}")
        print(f"{Colors.TOOL}Tool: {tool_name}{Colors.RESET}")
        print(f"{Colors.TOOL}Arguments:{Colors.RESET}")
        
        for key, value in arguments.items():
            # Truncate long values for display
            display_value = str(value)
            if len(display_value) > 200:
                display_value = display_value[:200] + "..."
            print(f"  {key}: {display_value}")
        
        response = input(f"\n{Colors.SYSTEM}Execute this tool? (y/N): {Colors.RESET}").strip().lower()
        return response == 'y'
    
    def format_size(self, size: int) -> str:
        """Format file size in human-readable format"""
        for unit in ['B', 'KB', 'MB', 'GB']:
            if size < 1024.0:
                return f"{size:.1f}{unit}"
            size /= 1024.0
        return f"{size:.1f}TB"
    
    def show_diff(self, old_content: str, new_content: str, filename: str) -> str:
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
                colored_diff.append(f"{Colors.DIFF_INFO}{line}{Colors.RESET}")
            elif line.startswith('@@'):
                colored_diff.append(f"{Colors.DIFF_INFO}{line}{Colors.RESET}")
            elif line.startswith('+'):
                colored_diff.append(f"{Colors.DIFF_ADD}{line}{Colors.RESET}")
            elif line.startswith('-'):
                colored_diff.append(f"{Colors.DIFF_DEL}{line}{Colors.RESET}")
            else:
                colored_diff.append(line)
        
        return '\n'.join(colored_diff)
    
    def confirm_tool(self, tool_name: str, arguments: Dict[str, Any], preview_diff: Optional[str] = None) -> bool:
        """Ask user for confirmation before executing a tool"""
        print(f"\n{Colors.TOOL}╔══════════════════════════════════════╗")
        print(f"║  Tool Call Confirmation Required     ║")
        print(f"╚══════════════════════════════════════╝{Colors.RESET}")
        print(f"{Colors.TOOL}Tool: {tool_name}{Colors.RESET}")
        print(f"{Colors.TOOL}Arguments:{Colors.RESET}")
        
        for key, value in arguments.items():
            # Truncate long values for display
            display_value = str(value)
            if len(display_value) > 200:
                display_value = display_value[:200] + "..."
            print(f"  {key}: {display_value}")
        
        # Show diff preview if available
        if preview_diff:
            print(f"\n{Colors.DIFF_INFO}═══ Diff Preview ═══{Colors.RESET}")
            print(preview_diff)
            print(f"{Colors.DIFF_INFO}═══ End of Diff ═══{Colors.RESET}")
        
        response = input(f"\n{Colors.SYSTEM}Execute this tool? (y/N): {Colors.RESET}").strip().lower()
        return response == 'y'
    
    def execute_tool(self, tool_name: str, arguments: Dict[str, Any]) -> str:
        """Execute a tool function"""
        try:
            if tool_name == "list_directory":
                path = arguments.get("path", ".")
                show_hidden = arguments.get("show_hidden", False)
                
                if not os.path.exists(path):
                    return f"Error: Path '{path}' does not exist"
                
                if not os.path.isdir(path):
                    return f"Error: '{path}' is not a directory"
                
                entries = []
                try:
                    items = os.listdir(path)
                except PermissionError:
                    return f"Error: Permission denied to access '{path}'"
                
                # Filter hidden files if needed
                if not show_hidden:
                    items = [item for item in items if not item.startswith('.')]
                
                # Sort: directories first, then files, both alphabetically
                items.sort(key=lambda x: (not os.path.isdir(os.path.join(path, x)), x.lower()))
                
                output = [f"Contents of '{os.path.abspath(path)}':\n"]
                output.append(f"{'Type':<6} {'Size':<10} {'Modified':<20} {'Name'}")
                output.append("-" * 70)
                
                for item in items:
                    full_path = os.path.join(path, item)
                    try:
                        stat = os.stat(full_path)
                        is_dir = os.path.isdir(full_path)
                        
                        type_str = "DIR" if is_dir else "FILE"
                        size_str = "-" if is_dir else self.format_size(stat.st_size)
                        mtime = datetime.fromtimestamp(stat.st_mtime).strftime("%Y-%m-%d %H:%M:%S")
                        
                        output.append(f"{type_str:<6} {size_str:<10} {mtime:<20} {item}")
                    except (OSError, PermissionError):
                        output.append(f"{'???':<6} {'???':<10} {'???':<20} {item} (access denied)")
                
                if len(items) == 0:
                    output.append("(empty directory)")
                else:
                    dir_count = sum(1 for item in items if os.path.isdir(os.path.join(path, item)))
                    file_count = len(items) - dir_count
                    output.append(f"\nTotal: {dir_count} directories, {file_count} files")
                
                return "\n".join(output)
            
            elif tool_name == "search_files":
                search_pattern = arguments["pattern"]
                file_pattern = arguments.get("file_pattern", "*")
                use_regex = arguments.get("regex", False)
                case_sensitive = arguments.get("case_sensitive", True)
                max_results = arguments.get("max_results", 100)
                include_hidden = arguments.get("include_hidden", False)
                context_lines = arguments.get("context_lines", 0)
                
                matches = []
                total_matches = 0
                start_path = os.getcwd()
                
                # Compile regex pattern if needed
                if use_regex:
                    try:
                        flags = 0 if case_sensitive else re.IGNORECASE
                        compiled_pattern = re.compile(search_pattern, flags)
                    except re.error as e:
                        return f"Invalid regex pattern: {e}"
                else:
                    compiled_pattern = None
                
                def should_skip(name):
                    """Check if file/dir should be skipped"""
                    if not include_hidden and name.startswith('.'):
                        return True
                    return False
                
                def match_line(line):
                    """Check if line matches the search pattern"""
                    if use_regex:
                        return compiled_pattern.search(line)
                    else:
                        if case_sensitive:
                            return search_pattern in line
                        else:
                            return search_pattern.lower() in line.lower()
                
                # Walk directory tree
                for root, dirs, files in os.walk(start_path):
                    # Filter out hidden directories if needed
                    if not include_hidden:
                        dirs[:] = [d for d in dirs if not d.startswith('.')]
                    
                    # Check files in current directory
                    for filename in files:
                        if should_skip(filename):
                            continue
                        
                        # Match against file pattern
                        if not fnmatch.fnmatch(filename, file_pattern):
                            continue
                        
                        full_path = os.path.join(root, filename)
                        rel_path = os.path.relpath(full_path, start_path)
                        
                        # Try to read file as text
                        try:
                            with open(full_path, 'r', encoding='utf-8', errors='ignore') as f:
                                lines = f.readlines()
                            
                            # Search through lines
                            for line_num, line in enumerate(lines, 1):
                                if total_matches >= max_results:
                                    break
                                
                                if match_line(line):
                                    # Get context lines if requested
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
                            # Skip binary files or files we can't read
                            continue
                        
                        if total_matches >= max_results:
                            break
                    
                    if total_matches >= max_results:
                        break
                
                if not matches:
                    return f"No matches found for pattern '{search_pattern}'"
                
                # Format output
                output = [f"Found {len(matches)} match(es) for '{search_pattern}'"]
                if len(matches) >= max_results:
                    output[0] += f" (limited to {max_results} results)"
                output.append("")
                
                current_file = None
                for match in matches:
                    # Print file header if this is a new file
                    if match['file'] != current_file:
                        if current_file is not None:
                            output.append("")  # Blank line between files
                        output.append(f"{Colors.DIFF_INFO}{match['file']}{Colors.RESET}")
                        current_file = match['file']
                    
                    # Print context before
                    if match['context_before']:
                        for ctx_line in match['context_before']:
                            output.append(f"  {Colors.SYSTEM}{ctx_line}{Colors.RESET}")
                    
                    # Print matching line with line number
                    output.append(f"{Colors.DIFF_ADD}{match['line_num']:>4}: {match['line']}{Colors.RESET}")
                    
                    # Print context after
                    if match['context_after']:
                        for ctx_line in match['context_after']:
                            output.append(f"  {Colors.SYSTEM}{ctx_line}{Colors.RESET}")
                
                return "\n".join(output)
            
            elif tool_name == "find_files":
                pattern = arguments["pattern"]
                max_depth = arguments.get("max_depth", None)
                include_hidden = arguments.get("include_hidden", False)
                
                matches = []
                start_path = os.getcwd()
                
                def should_skip(name):
                    """Check if file/dir should be skipped"""
                    if not include_hidden and name.startswith('.'):
                        return True
                    return False
                
                def get_depth(path, base):
                    """Calculate directory depth relative to base"""
                    rel_path = os.path.relpath(path, base)
                    if rel_path == '.':
                        return 0
                    return rel_path.count(os.sep) + 1
                
                # Walk directory tree
                for root, dirs, files in os.walk(start_path):
                    # Filter out hidden directories if needed
                    if not include_hidden:
                        dirs[:] = [d for d in dirs if not d.startswith('.')]
                    
                    # Check depth limit
                    current_depth = get_depth(root, start_path)
                    if max_depth is not None and current_depth >= max_depth:
                        dirs[:] = []  # Don't recurse deeper
                    
                    # Check files in current directory
                    for filename in files:
                        if should_skip(filename):
                            continue
                        
                        # Match against pattern
                        if fnmatch.fnmatch(filename, pattern):
                            full_path = os.path.join(root, filename)
                            rel_path = os.path.relpath(full_path, start_path)
                            
                            try:
                                stat = os.stat(full_path)
                                size = self.format_size(stat.st_size)
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
                
                # Format output
                output = [f"Found {len(matches)} file(s) matching '{pattern}':\n"]
                output.append(f"{'Size':<10} {'Modified':<20} {'Path'}")
                output.append("-" * 70)
                
                for match in matches:
                    output.append(f"{match['size']:<10} {match['modified']:<20} {match['path']}")
                
                return "\n".join(output)
            
            elif tool_name == "create_directory":
                path = arguments["path"]
                parents = arguments.get("parents", True)
                
                if os.path.exists(path):
                    if os.path.isdir(path):
                        return f"Directory '{path}' already exists"
                    else:
                        return f"Error: '{path}' exists but is not a directory"
                
                try:
                    if parents:
                        os.makedirs(path, exist_ok=True)
                        # Show what was created
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
            
            elif tool_name == "read_file":
                path = arguments["path"]
                with open(path, 'r', encoding='utf-8') as f:
                    content = f.read()
                return f"File contents of '{path}':\n{content}"
            
            elif tool_name == "write_file":
                path = arguments["path"]
                content = arguments["content"]
                
                # Check if file exists to show diff
                file_exists = os.path.exists(path)
                if file_exists:
                    try:
                        with open(path, 'r', encoding='utf-8') as f:
                            old_content = f.read()
                        result = f"Successfully overwrote '{path}'\n\nChanges made:\n"
                        result += self.show_diff(old_content, content, os.path.basename(path))
                    except Exception as e:
                        result = f"Successfully overwrote '{path}' (could not show diff: {e})"
                else:
                    result = f"Successfully created new file '{path}' ({len(content)} characters)"
                
                with open(path, 'w', encoding='utf-8') as f:
                    f.write(content)
                
                return result
            
            elif tool_name == "append_file":
                path = arguments["path"]
                content = arguments["content"]
                newline_before = arguments.get("newline_before", True)
                
                file_exists = os.path.exists(path)
                
                if file_exists:
                    try:
                        with open(path, 'r', encoding='utf-8') as f:
                            old_content = f.read()
                    except Exception as e:
                        return f"Error reading file for preview: {e}"
                    
                    # Prepare the content to append
                    append_content = ("\n" if newline_before and old_content and not old_content.endswith("\n") else "") + content
                    new_content = old_content + append_content
                    
                    # Write the file
                    with open(path, 'a', encoding='utf-8') as f:
                        f.write(append_content)
                    
                    # Show what was added
                    lines_added = content.count('\n') + (1 if content and not content.endswith('\n') else 0)
                    result = f"Successfully appended to '{path}' ({lines_added} line(s) added)\n\nAppended content:\n{Colors.DIFF_ADD}"
                    
                    # Show the appended content with + prefix like a diff
                    for line in content.splitlines():
                        result += f"+{line}\n"
                    result += Colors.RESET
                    
                    # Show context: last few lines of original + new content
                    old_lines = old_content.splitlines()
                    if len(old_lines) > 3:
                        result += f"\n{Colors.DIFF_INFO}Context (last 3 lines of original file):{Colors.RESET}\n"
                        for line in old_lines[-3:]:
                            result += f" {line}\n"
                else:
                    # Create new file
                    with open(path, 'w', encoding='utf-8') as f:
                        f.write(content)
                    result = f"Created new file '{path}' with appended content ({len(content)} characters)"
                
                return result
            
            elif tool_name == "edit_file":
                path = arguments["path"]
                old_text = arguments["old_text"]
                new_text = arguments["new_text"]
                
                with open(path, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                if old_text not in content:
                    return f"Error: Text to replace not found in '{path}'"
                
                new_content = content.replace(old_text, new_text)
                
                # Show diff
                diff_output = self.show_diff(content, new_content, os.path.basename(path))
                
                with open(path, 'w', encoding='utf-8') as f:
                    f.write(new_content)
                
                occurrences = content.count(old_text)
                return f"Successfully edited '{path}' ({occurrences} occurrence(s) replaced)\n\nChanges made:\n{diff_output}"
            
            elif tool_name == "run_command":
                command = arguments["command"]
                
                # Save to command history before execution
                history_entry = {
                    "command": command,
                    "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                }
                
                result = subprocess.run(
                    command,
                    shell=True,
                    capture_output=True,
                    text=True,
                    timeout=30
                )
                
                output = []
                if result.stdout:
                    output.append(f"STDOUT:\n{result.stdout}")
                if result.stderr:
                    output.append(f"STDERR:\n{result.stderr}")
                output.append(f"Return code: {result.returncode}")
                
                result_str = "\n".join(output)
                
                # Add result to history entry
                history_entry["result"] = result_str
                history_entry["return_code"] = result.returncode
                self.command_history.append(history_entry)
                
                return result_str
            
            else:
                return f"Error: Unknown tool '{tool_name}'"
        
        except Exception as e:
            return f"Error executing tool: {str(e)}"
    
    def show_command_history(self):
        """Display the command history"""
        if not self.command_history:
            print(f"{Colors.SYSTEM}No commands have been executed yet.{Colors.RESET}")
            return
        
        print(f"\n{Colors.SYSTEM}╔══════════════════════════════════════════════════════╗")
        print(f"║  Command History                                     ║")
        print(f"╚══════════════════════════════════════════════════════╝{Colors.RESET}\n")
        
        for idx, entry in enumerate(self.command_history, 1):
            status = f"{Colors.DIFF_ADD}✓{Colors.RESET}" if entry["return_code"] == 0 else f"{Colors.DIFF_DEL}✗{Colors.RESET}"
            print(f"{Colors.SYSTEM}[{idx}]{Colors.RESET} {status} {entry['timestamp']}")
            print(f"    Command: {Colors.TOOL}{entry['command']}{Colors.RESET}")
            print(f"    Return code: {entry['return_code']}\n")
    
    def rerun_command(self, index: int):
        """Rerun a command from history"""
        if not self.command_history:
            print(f"{Colors.ERROR}No commands in history.{Colors.RESET}")
            return
        
        if index < 1 or index > len(self.command_history):
            print(f"{Colors.ERROR}Invalid command index. Use 'history' to see available commands.{Colors.RESET}")
            return
        
        entry = self.command_history[index - 1]
        command = entry["command"]
        
        print(f"{Colors.SYSTEM}Rerunning command from history:{Colors.RESET}")
        print(f"{Colors.TOOL}{command}{Colors.RESET}\n")
        
        # Ask for confirmation
        response = input(f"{Colors.SYSTEM}Execute this command? (y/N): {Colors.RESET}").strip().lower()
        if response != 'y':
            print(f"{Colors.SYSTEM}Command execution cancelled.{Colors.RESET}")
            return
        
        # Execute the command
        print(f"{Colors.TOOL}[Executing...]{Colors.RESET}")
        result_str = self.execute_tool("run_command", {"command": command})
        print(f"{Colors.TOOL}Result: {result_str}{Colors.RESET}")
    
    def handle_special_commands(self, user_input: str) -> bool:
        """Handle special built-in commands. Returns True if handled."""
        cmd = user_input.lower().strip()
        
        if cmd in ['exit', 'quit']:
            print(f"{Colors.SYSTEM}Goodbye!{Colors.RESET}")
            return True
        
        if cmd == 'clear':
            self.conversation = []
            print(f"{Colors.SYSTEM}Conversation history cleared{Colors.RESET}")
            return True
        
        if cmd == 'history':
            self.show_command_history()
            return True
        
        # Handle rerun commands: !1, !2, !3, etc.
        if cmd.startswith('!') and len(cmd) > 1:
            try:
                index = int(cmd[1:])
                self.rerun_command(index)
            except ValueError:
                print(f"{Colors.ERROR}Invalid command format. Use !<number> (e.g., !1, !2){Colors.RESET}")
            return True
        
        return False
    
    def process_message(self, user_input: str):
        """Process a user message and handle tool calls"""
        # Add user message to conversation
        self.conversation.append({"role": "user", "content": user_input})
        
        # Prepare messages with system prompt
        messages = [{"role": "system", "content": self.system_prompt}] + self.conversation
        
        max_iterations = 10
        iteration = 0
        
        while iteration < max_iterations:
            iteration += 1
            
            # Call API
            if SHOW_THINKING and not STREAM_OUTPUT:
                print(f"{Colors.THINKING}[Thinking...]{Colors.RESET}")
            
            response = self.call_api(messages)
            
            if not response:
                print(f"{Colors.ERROR}Failed to get response from API{Colors.RESET}")
                return
            
            # Extract assistant message
            choice = response.get("choices", [{}])[0]
            message = choice.get("message", {})
            
            # Check for tool calls
            tool_calls = message.get("tool_calls", [])
            
            # Display thinking/reasoning if available and enabled
            content = message.get("content", "")
            
            # Handle content display based on mode
            if not tool_calls:
                # No tool calls - this is the final response
                if content:
                    if not STREAM_OUTPUT:
                        # Non-streaming mode: display the content now
                        if SHOW_THINKING:
                            # Show as thinking in magenta
                            print(f"{Colors.THINKING}{content}{Colors.RESET}")
                        else:
                            # Show as regular assistant message in green
                            print(f"{Colors.ASSISTANT}{content}{Colors.RESET}")
                    # else: already streamed in real-time
                    
                    self.conversation.append({"role": "assistant", "content": content})
                break
            
            # Process tool calls
            self.conversation.append(message)
            
            for tool_call in tool_calls:
                func = tool_call.get("function", {})
                tool_name = func.get("name")
                arguments = json.loads(func.get("arguments", "{}"))
                tool_id = tool_call.get("id")
                
                # Generate diff preview for edit operations
                preview_diff = None
                if tool_name == "edit_file":
                    try:
                        path = arguments.get("path")
                        old_text = arguments.get("old_text")
                        new_text = arguments.get("new_text")
                        
                        if path and os.path.exists(path):
                            with open(path, 'r', encoding='utf-8') as f:
                                content = f.read()
                            
                            if old_text in content:
                                new_content = content.replace(old_text, new_text)
                                preview_diff = self.show_diff(content, new_content, os.path.basename(path))
                    except Exception:
                        pass  # If preview fails, continue without it
                
                elif tool_name == "write_file":
                    try:
                        path = arguments.get("path")
                        new_content = arguments.get("content", "")
                        
                        if path and os.path.exists(path):
                            with open(path, 'r', encoding='utf-8') as f:
                                old_content = f.read()
                            preview_diff = self.show_diff(old_content, new_content, os.path.basename(path))
                    except Exception:
                        pass  # If preview fails, continue without it
                
                elif tool_name == "append_file":
                    try:
                        path = arguments.get("path")
                        content = arguments.get("content", "")
                        newline_before = arguments.get("newline_before", True)
                        
                        if path and os.path.exists(path):
                            with open(path, 'r', encoding='utf-8') as f:
                                old_content = f.read()
                            
                            # Prepare the content to append
                            append_content = ("\n" if newline_before and old_content and not old_content.endswith("\n") else "") + content
                            new_content = old_content + append_content
                            preview_diff = self.show_diff(old_content, new_content, os.path.basename(path))
                    except Exception:
                        pass  # If preview fails, continue without it
                
                # Ask for confirmation with preview
                if self.confirm_tool(tool_name, arguments, preview_diff):
                    if SHOW_THINKING:
                        print(f"{Colors.TOOL}[Executing...]{Colors.RESET}")
                    result = self.execute_tool(tool_name, arguments)
                    print(f"{Colors.TOOL}Result: {result}{Colors.RESET}")
                else:
                    result = "User declined to execute this tool"
                    if SHOW_THINKING:
                        print(f"{Colors.SYSTEM}{result}{Colors.RESET}")
                
                # Add tool response to conversation
                self.conversation.append({
                    "role": "tool",
                    "tool_call_id": tool_id,
                    "content": result
                })
            
            # Continue with updated conversation
            messages = [{"role": "system", "content": self.system_prompt}] + self.conversation
    
    def run(self):
        """Main interaction loop"""
        readline_status = "ENABLED" if READLINE_AVAILABLE else "DISABLED"
        print(f"{Colors.SYSTEM}╔══════════════════════════════════════════════════════╗")
        print(f"║  Coding Assistant with llama.cpp                     ║")
        print(f"║  Commands:                                          ║")
        print(f"║    exit/quit  - End the session                     ║")
        print(f"║    clear      - Clear conversation history          ║")
        print(f"║    history    - Show command history                ║")
        print(f"║    !<number>  - Rerun command (e.g., !1, !2)        ║")
        print(f"║                                                      ║")
        print(f"║  SHOW_THINKING: {'ON ' if SHOW_THINKING else 'OFF'}                              ║")
        print(f"║  STREAM_OUTPUT: {'ON ' if STREAM_OUTPUT else 'OFF'}                              ║")
        print(f"║  READLINE:      {readline_status:<7}                         ║")
        if READLINE_AVAILABLE:
            print(f"║    ↑/↓        - Navigate input history              ║")
            print(f"║    ←/→        - Move cursor                          ║")
            print(f"║    Home/End   - Jump to start/end of line           ║")
            print(f"║    Ctrl+←/→   - Jump by word                        ║")
        print(f"╚══════════════════════════════════════════════════════╝{Colors.RESET}\n")
        
        while True:
            try:
                user_input = input(f"{Colors.USER}You: {Colors.RESET}").strip()
                
                if not user_input:
                    continue
                
                # Save to input history
                self._save_input_to_history(user_input)
                
                # Handle special commands
                if self.handle_special_commands(user_input):
                    if user_input.lower() in ['exit', 'quit']:
                        break
                    continue
                
                self.process_message(user_input)
                print()  # Empty line for readability
                
            except KeyboardInterrupt:
                print(f"\n{Colors.SYSTEM}Interrupted. Type 'exit' to quit.{Colors.RESET}")
            except EOFError:
                print(f"\n{Colors.SYSTEM}Goodbye!{Colors.RESET}")
                break
            except Exception as e:
                print(f"{Colors.ERROR}Error: {e}{Colors.RESET}")

def main():
    # You can change the server URL here or pass it as an argument
    server_url = "http://127.0.0.1:8033"
    
    if len(sys.argv) > 1:
        server_url = sys.argv[1]
    
    print(f"{Colors.SYSTEM}Starting Coding Assistant...{Colors.RESET}")
    print(f"{Colors.SYSTEM}Connecting to llama.cpp server at: {server_url}{Colors.RESET}\n")
    
    assistant = CodingAssistant(server_url)
    assistant.run()

if __name__ == "__main__":
    main()