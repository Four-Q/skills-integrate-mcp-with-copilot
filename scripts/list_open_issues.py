#!/usr/bin/env python3
"""Fetch open issues (not PRs) for this repo and print number, title, labels, comments, body (truncated) and comments text."""
import os
import sys
import json
import urllib.request

TOKEN = os.environ.get('GITHUB_TOKEN')
if not TOKEN:
    print('GITHUB_TOKEN not set', file=sys.stderr)
    sys.exit(1)

REPO = os.environ.get('REPO', 'Four-Q/skills-integrate-mcp-with-copilot')

def gh_get(url):
    req = urllib.request.Request(url)
    req.add_header('Authorization', f'token {TOKEN}')
    req.add_header('Accept', 'application/vnd.github.v3+json')
    with urllib.request.urlopen(req) as resp:
        return json.load(resp)

def main():
    issues_url = f'https://api.github.com/repos/{REPO}/issues?state=open&per_page=100'
    issues = gh_get(issues_url)
    print(f'Found {len(issues)} open issues (includes only issues, not PRs).\n')
    for i in issues:
        num = i.get('number')
        title = i.get('title')
        labels = ','.join([l.get('name') for l in i.get('labels', [])])
        comments = i.get('comments', 0)
        url = i.get('html_url')
        body = (i.get('body') or '(no body)').strip().replace('\n',' ')[:500]
        print('===' + ' ISSUE ' + str(num) + ' ===')
        print('Title:', title)
        print('URL:', url)
        print('Labels:', labels)
        print('Comments:', comments)
        print('Body (truncated):', body)
        if comments:
            comments_url = i.get('comments_url')
            try:
                cs = gh_get(comments_url)
                print('--- COMMENTS ---')
                for c in cs:
                    user = c.get('user', {}).get('login')
                    created = c.get('created_at')
                    cbody = (c.get('body') or '').strip().replace('\n',' ')
                    print(f'({user}) {created}\n{cbody}\n----')
            except Exception as e:
                print('Failed to fetch comments:', e, file=sys.stderr)
        print('\n')

if __name__ == '__main__':
    main()
