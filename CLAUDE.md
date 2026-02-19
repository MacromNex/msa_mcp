# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MSA MCP is a FastMCP server that generates Multiple Sequence Alignments (MSA) for protein sequences using the ColabFold/MMseqs2 API (`https://api.colabfold.com`). It exposes a single tool (`generate_msa`) that submits a sequence, polls for completion, and downloads the resulting A3M alignment file.

## Architecture

- **`src/server.py`** — Entry point. Creates the root `FastMCP(name="msa")` instance and mounts the sub-server.
- **`src/tools/msa_generation.py`** — Contains the `generate_msa` tool and three helper functions (`submit_job`, `poll_status`, `download_results`) that implement the ColabFold API workflow. Defines the `msa_generation_mcp` sub-server that gets mounted into the root server.

The server uses FastMCP's mount pattern: `msa_generation_mcp` (sub-server) is mounted onto the root `mcp` instance in `server.py`.

## Running the Server

```bash
python src/server.py
```

Or register with Claude Code:
```bash
claude mcp add msa -- python <path-to-repo>/src/server.py
```

## Setup

```bash
bash quick_setup.sh          # installs fastmcp + requests via pip
bash quick_setup.sh --skip-env  # skip dependency install
```

Dependencies: `fastmcp`, `requests` (no requirements.txt — installed directly by setup script).

## Key Configuration

- **Output directory**: `tmp/outputs/` (override with `MSA_GENERATION_OUTPUT_DIR` env var)
- **Input directory**: `tmp/inputs/` (override with `MSA_GENERATION_INPUT_DIR` env var)
- **ColabFold API**: `https://api.colabfold.com` (hardcoded in `MSA_SERVER_URL`)
- MSA generation requires internet access and typically takes 2-10 minutes per sequence.

## Notes

- No test suite exists in the repo.
- The `examples/` directory contains sample FASTA files (DHFR.fasta, GB1.fasta) and `scripts/create_msa.ipynb` has a notebook version of the workflow.
- Valid amino acid characters: `ACDEFGHIKLMNPQRSTVWY` — the tool validates input sequences against this set.
