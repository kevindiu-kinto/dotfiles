#!/bin/bash
# Quick setup script for the development environment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    print_success "Docker and Docker Compose are installed"
}

# Build and start the environment
build_environment() {
    print_status "Building development environment..."
    
    if docker-compose build; then
        print_success "Environment built successfully"
    else
        print_error "Failed to build environment"
        exit 1
    fi
}

start_environment() {
    print_status "Starting development environment..."
    
    if docker-compose up -d; then
        print_success "Environment started successfully"
    else
        print_error "Failed to start environment"
        exit 1
    fi
}

# Wait for services to be ready
wait_for_services() {
    print_status "Waiting for services to be ready..."
    
    # Wait for SSH service
    for i in {1..30}; do
        if docker exec dev-environment pgrep sshd > /dev/null 2>&1; then
            print_success "SSH service is ready"
            break
        fi
        
        if [ $i -eq 30 ]; then
            print_warning "SSH service may not be ready yet"
            break
        fi
        
        sleep 2
    done
}

# Install vim plugins
install_vim_plugins() {
    print_status "Installing Vim plugins..."
    docker exec dev-environment vim +PlugInstall +qall || true
    print_success "Vim plugins installation initiated"
}

# Show connection information
show_connection_info() {
    echo ""
    echo "🎉 Development environment is ready!"
    echo ""
    echo "📡 Connection Information:"
    echo "   SSH: ssh dev@localhost -p 2222 (password: dev)"
    echo "   Direct: docker exec -it dev-environment zsh"
    echo ""
    echo "🔧 VS Code Remote SSH:"
    echo "   1. Install 'Remote - SSH' extension"
    echo "   2. Add to ~/.ssh/config:"
    echo "      Host dev-environment"
    echo "        HostName localhost"
    echo "        Port 2222"
    echo "        User dev"
    echo "   3. Connect via Command Palette: 'Remote-SSH: Connect to Host'"
    echo ""
    echo "📁 Your code goes in: ./workspace/"
    echo "⚙️  Configs are in: ./configs/"
    echo ""
    echo "🚀 Happy coding!"
}

# Main setup function
main() {
    echo "🐳 Setting up your development environment..."
    echo ""
    
    check_docker
    build_environment
    start_environment
    wait_for_services
    install_vim_plugins
    show_connection_info
}

# Run main function
main "$@"