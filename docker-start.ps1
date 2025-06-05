# RAG Application Docker Management Script for Windows PowerShell
# Usage: .\docker-start.ps1 [command]

param(
    [string]$Command = "help"
)

# Colors for output
$Red = "Red"
$Green = "Green"
$Yellow = "Yellow"
$Blue = "Blue"

function Write-ColorText {
    param($Text, $Color)
    Write-Host $Text -ForegroundColor $Color
}

function Show-Help {
    Write-ColorText "RAG Application Docker Management" $Blue
    Write-ColorText "=================================" $Blue
    Write-Host ""
    Write-Host "Available commands:"
    Write-Host "  start         - Build and start all services"
    Write-Host "  dev           - Start in development mode with hot reload"
    Write-Host "  stop          - Stop all services"
    Write-Host "  restart       - Restart all services"
    Write-Host "  logs          - Show logs from all services"
    Write-Host "  logs-api      - Show API service logs"
    Write-Host "  logs-frontend - Show frontend service logs"
    Write-Host "  status        - Show service status"
    Write-Host "  build         - Build all services"
    Write-Host "  clean         - Stop and remove all containers and volumes"
    Write-Host "  shell-api     - Open shell in API container"
    Write-Host "  shell-frontend- Open shell in frontend container"
    Write-Host "  setup         - Initial setup (create .env file)"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\docker-start.ps1 start"
    Write-Host "  .\docker-start.ps1 dev"
    Write-Host "  .\docker-start.ps1 logs-api"
}

function Test-DockerInstalled {
    try {
        docker --version | Out-Null
        docker-compose --version | Out-Null
        return $true
    }
    catch {
        Write-ColorText "Error: Docker or Docker Compose is not installed or not in PATH" $Red
        Write-Host "Please install Docker Desktop from https://www.docker.com/products/docker-desktop"
        return $false
    }
}

function Test-EnvFile {
    if (-not (Test-Path ".env")) {
        Write-ColorText "Warning: .env file not found" $Yellow
        Write-Host "Run '.\docker-start.ps1 setup' to create one, or copy .env.example to .env"
        return $false
    }
    return $true
}

function Setup-Environment {
    Write-ColorText "Setting up environment..." $Blue
    
    if (Test-Path ".env") {
        Write-ColorText ".env file already exists" $Yellow
        $response = Read-Host "Do you want to overwrite it? (y/N)"
        if ($response -ne "y" -and $response -ne "Y") {
            Write-ColorText "Setup cancelled" $Yellow
            return
        }
    }
    
    if (Test-Path ".env.example") {
        Copy-Item ".env.example" ".env"
        Write-ColorText ".env file created from .env.example" $Green
    }
    else {
        # Create basic .env file
        @"
# Environment variables for RAG application
GOOGLE_API_KEY=your_google_api_key_here
SQLALCHEMY_DATABASE_URL=sqlite:///./documents.db
PYTHONPATH=/app
API_HOST=0.0.0.0
API_PORT=8000
FRONTEND_PORT=3000
"@ | Out-File -FilePath ".env" -Encoding utf8
        Write-ColorText ".env file created" $Green
    }
    
    Write-ColorText "Please edit .env file and add your Google API key" $Yellow
    Write-Host "You can use: notepad .env"
}

# Check if Docker is installed
if (-not (Test-DockerInstalled)) {
    exit 1
}

# Execute commands
switch ($Command.ToLower()) {
    "start" {
        Write-ColorText "Starting RAG application..." $Blue
        Test-EnvFile | Out-Null
        docker-compose up --build -d
        Write-ColorText "Services started successfully!" $Green
        Write-Host "Frontend: http://localhost:3000"
        Write-Host "API: http://localhost:8000"
        Write-Host "API Docs: http://localhost:8000/docs"
    }
    
    "dev" {
        Write-ColorText "Starting RAG application in development mode..." $Blue
        Test-EnvFile | Out-Null
        docker-compose -f docker-compose.yml -f docker-compose.dev.yml up --build
    }
    
    "stop" {
        Write-ColorText "Stopping services..." $Blue
        docker-compose down
        Write-ColorText "Services stopped" $Green
    }
    
    "restart" {
        Write-ColorText "Restarting services..." $Blue
        docker-compose restart
        Write-ColorText "Services restarted" $Green
    }
    
    "logs" {
        docker-compose logs -f
    }
    
    "logs-api" {
        docker-compose logs -f api
    }
    
    "logs-frontend" {
        docker-compose logs -f frontend
    }
    
    "status" {
        Write-ColorText "Service Status:" $Blue
        docker-compose ps
    }
    
    "build" {
        Write-ColorText "Building services..." $Blue
        docker-compose build
        Write-ColorText "Build completed" $Green
    }
    
    "clean" {
        Write-ColorText "Cleaning up (this will remove all data!)..." $Red
        $response = Read-Host "Are you sure? This will delete all uploaded files and database (y/N)"
        if ($response -eq "y" -or $response -eq "Y") {
            docker-compose down -v --remove-orphans
            docker system prune -f
            Write-ColorText "Cleanup completed" $Green
        }
        else {
            Write-ColorText "Cleanup cancelled" $Yellow
        }
    }
    
    "shell-api" {
        Write-ColorText "Opening shell in API container..." $Blue
        docker-compose exec api bash
    }
    
    "shell-frontend" {
        Write-ColorText "Opening shell in frontend container..." $Blue
        docker-compose exec frontend bash
    }
    
    "setup" {
        Setup-Environment
    }
    
    "help" {
        Show-Help
    }
    
    default {
        Write-ColorText "Unknown command: $Command" $Red
        Show-Help
        exit 1
    }
}
