#!/usr/bin/env python3
"""
Script to graph open/closed issues over time for a Gitea repository.
Fetches all issues via Gitea API and creates a time-series visualization.
Requirements: requests>=2.31.0 matplotlib>=3.7.0 urllib3>=2.0.0
"""

import requests
from datetime import datetime, timedelta
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from collections import defaultdict
import argparse

def fetch_all_issues(gitea_url, owner, repo, token=None, verify_ssl=True):
    """
    Fetch all issues (open and closed) from a Gitea repository.
    
    Args:
        gitea_url: Base URL of Gitea instance (e.g., 'https://gitea.example.com')
        owner: Repository owner username
        repo: Repository name
        token: Optional API token for authentication
        verify_ssl: Whether to verify SSL certificates (default: True)
    
    Returns:
        List of issue dictionaries
    """
    all_issues = []
    page = 1
    per_page = 100
    
    headers = {}
    if token:
        headers['Authorization'] = f'token {token}'
    
    # Suppress SSL warnings if verification is disabled
    if not verify_ssl:
        import urllib3
        urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
    
    while True:
        # Fetch both open and closed issues
        url = f"{gitea_url}/api/v1/repos/{owner}/{repo}/issues"
        params = {
            'state': 'all',  # Get both open and closed
            'page': page,
            'limit': per_page
        }
        
        print(f"Fetching page {page}...")
        response = requests.get(url, params=params, headers=headers, verify=verify_ssl)
        response.raise_for_status()
        
        issues = response.json()
        if not issues:
            break
            
        all_issues.extend(issues)
        page += 1
    
    print(f"Fetched {len(all_issues)} total issues")
    return all_issues

def calculate_issue_counts_over_time(issues, start_date, end_date):
    """
    Calculate number of open/closed issues at each point in time.
    
    Args:
        issues: List of issue dictionaries from Gitea API
        start_date: datetime object for start of time range
        end_date: datetime object for end of time range
    
    Returns:
        Tuple of (dates, open_counts, closed_counts)
    """
    # Create daily snapshots
    current_date = start_date
    dates = []
    open_counts = []
    closed_counts = []
    
    while current_date <= end_date:
        dates.append(current_date)
        
        open_count = 0
        closed_count = 0
        
        for issue in issues:
            created_at = datetime.fromisoformat(issue['created_at'].replace('Z', '+00:00'))
            
            # Check if issue was created before or on this date
            if created_at.date() <= current_date.date():
                # Check if it's still open or was closed after this date
                if issue['closed_at'] is None:
                    # Still open
                    open_count += 1
                else:
                    closed_at = datetime.fromisoformat(issue['closed_at'].replace('Z', '+00:00'))
                    if closed_at.date() > current_date.date():
                        # Was open on this date
                        open_count += 1
                    else:
                        # Was already closed on this date
                        closed_count += 1
        
        open_counts.append(open_count)
        closed_counts.append(closed_count)
        
        # Move to next week (you can change this interval)
        current_date += timedelta(days=7)
    
    return dates, open_counts, closed_counts

def plot_issues(dates, open_counts, closed_counts, repo_name, output_file='issue_graph.png', open_only=False):
    """
    Create a graph showing open and closed issues over time.
    
    Args:
        dates: List of datetime objects
        open_counts: List of open issue counts
        closed_counts: List of closed issue counts
        repo_name: Name of repository for title
        output_file: Output filename for the graph
        open_only: If True, only plot open issues
    """
    fig, ax = plt.subplots(figsize=(14, 7))
    
    # Plot lines
    ax.plot(dates, open_counts, label='Open Issues', color='#e74c3c', linewidth=2)
    ax.fill_between(dates, open_counts, alpha=0.3, color='#e74c3c')
    
    if not open_only:
        ax.plot(dates, closed_counts, label='Closed Issues', color='#27ae60', linewidth=2)
        ax.fill_between(dates, closed_counts, alpha=0.3, color='#27ae60')
    
    # Formatting
    ax.set_xlabel('Date', fontsize=12)
    ax.set_ylabel('Number of Issues', fontsize=12)
    ax.set_title(f'Issue Statistics Over Time - {repo_name}', fontsize=14, fontweight='bold')
    ax.legend(loc='upper left', fontsize=11)
    ax.grid(True, alpha=0.3)
    
    # Format x-axis dates
    ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y-%m'))
    ax.xaxis.set_major_locator(mdates.YearLocator())
    ax.xaxis.set_minor_locator(mdates.MonthLocator((1, 4, 7, 10)))
    plt.xticks(rotation=45, ha='right')
    
    plt.tight_layout()
    plt.savefig(output_file, dpi=300, bbox_inches='tight')
    print(f"Graph saved to {output_file}")
    plt.show()

def main():
    parser = argparse.ArgumentParser(description='Graph Gitea repository issues over time')
    parser.add_argument('--url', required=True, help='Gitea instance URL (e.g., https://gitea.example.com)')
    parser.add_argument('--owner', required=True, help='Repository owner username')
    parser.add_argument('--repo', required=True, help='Repository name')
    parser.add_argument('--token', help='Gitea API token (optional, for private repos)')
    parser.add_argument('--years', type=int, default=10, help='Number of years to look back (default: 10)')
    parser.add_argument('--output', default='issue_graph.png', help='Output filename (default: issue_graph.png)')
    parser.add_argument('--insecure', action='store_true', help='Disable SSL certificate verification')
    parser.add_argument('--open-only', action='store_true', help='Only graph open issues, not closed ones')
    
    args = parser.parse_args()
    
    # Calculate date range
    end_date = datetime.now()
    start_date = end_date - timedelta(days=365 * args.years)
    
    print(f"Analyzing issues from {start_date.date()} to {end_date.date()}")
    print(f"Repository: {args.owner}/{args.repo}")
    print()
    
    # Fetch issues
    issues = fetch_all_issues(args.url, args.owner, args.repo, args.token, verify_ssl=not args.insecure)
    
    if not issues:
        print("No issues found!")
        return
    
    # Calculate counts over time
    print("Calculating issue statistics over time...")
    dates, open_counts, closed_counts = calculate_issue_counts_over_time(issues, start_date, end_date)
    
    # Create graph
    print("Generating graph...")
    plot_issues(dates, open_counts, closed_counts, f"{args.owner}/{args.repo}", args.output, open_only=args.open_only)
    
    # Print summary statistics
    print("\n=== Summary Statistics ===")
    print(f"Total issues ever created: {len(issues)}")
    print(f"Currently open: {open_counts[-1]}")
    print(f"Currently closed: {closed_counts[-1]}")
    print(f"Peak open issues: {max(open_counts)} on {dates[open_counts.index(max(open_counts))].date()}")

if __name__ == '__main__':
    main()
