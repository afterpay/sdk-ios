# Bug Bounty

This repository participates in Block's Bug Bounty Program for open source projects.

If you find a security vulnerability, please report it through our bug bounty program on Bugcrowd: https://bugcrowd.com/engagements/blockopensource

## Rewards

Bounties range from $100 to $5,000 depending on severity and impact:

| Priority | Reward Range |
|----------|--------------|
| P1 | $2,500 - $5,000 |
| P2 | $1,000 - $1,500 |
| P3 | $250 - $500 |
| P4 | $100 - $200 |

## What's In Scope

Only the latest release or main branch of this repository is eligible for rewards. We're looking for real security issues with actual exploitability - not just outdated dependencies or theoretical problems.

Reports should include:
- Clear proof-of-concept showing the vulnerability
- Specific file and line references in the code
- Description of the real-world impact
- Steps to reproduce

We won't accept reports for:
- Old releases or development branches
- Issues already publicly tracked or fixed
- Problems without demonstrable exploitation
- Outdated library versions alone (unless you can show actual impact)

## How to Report

**Don't open public issues or pull requests for security bugs.** That would reveal the vulnerability before we can fix it.

Report through either:

**GitHub Security Tab** (easier)
- Go to the Security tab on this repo
- Click "Report a vulnerability"  
- Fill out the form

**Bugcrowd** (for bounty tracking)
- Submit at https://bugcrowd.com/engagements/blockopensource
- Make sure to include repo name, version, and specific code references

## Rules

Read the [CONTRIBUTING.md](CONTRIBUTING.md) before you start testing.

When testing:
- Only test on your own local setup
- If you access any real customer data, stop immediately and report it
- Don't attempt DoS attacks
- Keep your findings private until we've fixed the issue
- Delete any sensitive data you found during testing

**Important:** Don't use ChatGPT, Claude, DeepSeek, or any other AI tools during your security research. This protects both you and the data you might encounter.

For questions or updates on your submission, contact support@bugcrowd.com - don't reach out to Block directly.

## Submitting a Fix

Have a fix for the vulnerability? Great! But don't open a public PR - that would expose the issue. Instead, include your fix in the private security advisory when you report it.

## Safe Harbor

We won't take legal action against researchers who follow these rules and report issues responsibly.
