#!/bin/bash
#===============================================================================
# MSA MCP Quick Setup Script
#===============================================================================
# This script sets up the complete environment for MSA MCP server.
# Generate Multiple Sequence Alignments (MSA) using ColabFold server.
#
# After cloning the repository, run this script to set everything up:
#   cd msa_mcp
#   bash quick_setup.sh
#
# Once setup is complete, register in Claude Code with the config shown at the end.
#
# Options:
#   --skip-env        Skip environment setup
#   --help            Show this help message
#===============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_DIR="${SCRIPT_DIR}/env"

# Print banner
echo -e "${BLUE}"
echo "=============================================="
echo "        MSA MCP Quick Setup Script           "
echo "=============================================="
echo -e "${NC}"

# Helper functions
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Parse arguments
SKIP_ENV=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-env) SKIP_ENV=true; shift ;;
        -h|--help)
            echo "Usage: ./quick_setup.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --skip-env        Skip environment setup"
            echo "  -h, --help        Show this help message"
            exit 0
            ;;
        *) warn "Unknown option: $1"; shift ;;
    esac
done

# Check prerequisites
info "Checking prerequisites..."

if ! command -v python3 &> /dev/null; then
    error "python3 is not installed. Please install Python 3 first."
    exit 1
fi
success "Prerequisites check passed"

# Step 1: Install dependencies
echo ""
echo -e "${BLUE}Step 1: Installing dependencies${NC}"

if [ "$SKIP_ENV" = true ]; then
    info "Skipping environment setup (--skip-env)"
else
    info "Installing fastmcp and requests..."
    pip install fastmcp requests
    success "Dependencies installed"
fi

# Step 2: Verify installation
echo ""
echo -e "${BLUE}Step 2: Verifying installation${NC}"

python3 -c "import fastmcp; import requests; print('Core packages OK')" && success "Core packages verified" || error "Package verification failed"

# Print summary
echo ""
echo -e "${GREEN}=============================================="
echo "           Setup Complete!"
echo "==============================================${NC}"
echo ""
echo -e "${YELLOW}Note:${NC} This MCP uses the ColabFold MSA server (requires internet)."
echo ""
echo -e "${YELLOW}Claude Code Configuration:${NC}"
echo ""
cat << EOF
{
  "mcpServers": {
    "msa": {
      "command": "python",
      "args": ["${SCRIPT_DIR}/src/msa_mcp.py"]
    }
  }
}
EOF
echo ""
echo "To add to Claude Code:"
echo "  claude mcp add msa -- python ${SCRIPT_DIR}/src/msa_mcp.py"
echo ""
