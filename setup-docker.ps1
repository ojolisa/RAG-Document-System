# RAG Application Complete Setup Script
# This script sets up the entire Docker environment for the RAG application

param(
    [switch]$Production,
    [switch]$Development,
    [string]$ApiKey = ""
)

$ErrorActionPreference = "Stop"

# Colors for output
function Write-ColorText {
    param($Text, $Color)
    Write-Host $Text -ForegroundColor $Color
}

function Write-Step {
    param($Step, $Text)
    Write-Host ""
    Write-ColorText "[$Step] $Text" "Cyan"
}

function Write-Success {
    param($Text)
    Write-ColorText "✓ $Text" "Green"
}

function Write-Warning {
    param($Text)
    Write-ColorText "⚠ $Text" "Yellow"
}

function Write-Error {
    param($Text)
    Write-ColorText "✗ $Text" "Red"
}

Write-ColorText @"
================================================================
RAG Application Docker Setup
================================================================
This script will set up your RAG application with Docker Compose
"@ "Blue"

# Step 1: Check prerequisites
Write-Step "1" "Checking prerequisites..."

try {
    docker --version | Out-Null
    Write-Success "Docker is installed"
}
catch {
    Write-Error "Docker is not installed. Please install Docker Desktop first."
    exit 1
}

try {
    docker-compose --version | Out-Null
    Write-Success "Docker Compose is available"
}
catch {
    Write-Error "Docker Compose is not available. Please install Docker Desktop."
    exit 1
}

# Step 2: Create environment file
Write-Step "2" "Setting up environment configuration..."

if (Test-Path ".env") {
    Write-Warning ".env file already exists"
    $overwrite = Read-Host "Do you want to overwrite it? (y/N)"
    if ($overwrite -ne "y" -and $overwrite -ne "Y") {
        Write-ColorText "Using existing .env file" "Yellow"
    }
    else {
        Remove-Item ".env"
    }
}

if (-not (Test-Path ".env")) {
    if ($ApiKey -eq "") {
        Write-Host ""
        Write-ColorText "You need a Google Gemini API key for the RAG functionality." "Yellow"
        Write-Host "Get one from: https://aistudio.google.com/app/apikey"
        Write-Host ""
        $ApiKey = Read-Host "Enter your Google Gemini API key (or press Enter to set it later)"
        if ($ApiKey -eq "") {
            $ApiKey = "your_google_api_key_here"
            Write-Warning "You'll need to edit .env file later to add your API key"
        }
    }
    
    $envContent = @"
# RAG Application Environment Configuration
# Generated on $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

# Google Gemini API Key (Required)
GOOGLE_API_KEY=$ApiKey

# Database Configuration
SQLALCHEMY_DATABASE_URL=sqlite:///./documents.db

# Application Configuration
PYTHONPATH=/app
API_HOST=0.0.0.0
API_PORT=8000
FRONTEND_PORT=3000

# Development Settings
DEVELOPMENT_MODE=false
"@
    
    $envContent | Out-File -FilePath ".env" -Encoding utf8
    Write-Success "Environment file created"
}

# Step 3: Create necessary directories
Write-Step "3" "Creating necessary directories..."

$directories = @("rag/pdfs", "api", "frontend", "nginx/ssl")
foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Success "Created directory: $dir"
    }
}

# Step 4: Set execution policy for scripts
Write-Step "4" "Setting up PowerShell execution policy..."
try {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Write-Success "PowerShell execution policy updated"
}
catch {
    Write-Warning "Could not update PowerShell execution policy. You may need to run scripts with different permissions."
}

# Step 5: Build and start services
Write-Step "5" "Building and starting services..."

if ($Production) {
    Write-ColorText "Starting in PRODUCTION mode..." "Red"
    docker-compose -f docker-compose.yml -f docker-compose.prod.yml up --build -d
}
elseif ($Development) {
    Write-ColorText "Starting in DEVELOPMENT mode..." "Yellow"
    docker-compose -f docker-compose.yml -f docker-compose.dev.yml up --build -d
}
else {
    Write-ColorText "Starting in STANDARD mode..." "Green"
    docker-compose up --build -d
}

# Step 6: Wait for services to be ready
Write-Step "6" "Waiting for services to start..."

$maxWait = 60
$waited = 0
$apiReady = $false

Write-Host "Checking API health..." -NoNewline
while ($waited -lt $maxWait -and -not $apiReady) {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8000/health" -TimeoutSec 2 -UseBasicParsing
        if ($response.StatusCode -eq 200) {
            $apiReady = $true
            Write-Host " Ready!" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "." -NoNewline
        Start-Sleep 2
        $waited += 2
    }
}

if (-not $apiReady) {
    Write-Warning "API took longer than expected to start. Check logs with: docker-compose logs api"
}

# Step 7: Display results
Write-Step "7" "Setup complete!"

Write-Host ""
Write-ColorText "🚀 RAG Application is now running!" "Green"
Write-Host ""
Write-ColorText "Access URLs:" "Blue"
Write-Host "  Frontend:        http://localhost:3000"
Write-Host "  API:            http://localhost:8000"
Write-Host "  API Documentation: http://localhost:8000/docs"
Write-Host ""

Write-ColorText "Management Commands:" "Blue"
Write-Host "  View logs:      docker-compose logs -f"
Write-Host "  Stop services:  docker-compose down"
Write-Host "  Restart:        docker-compose restart"
Write-Host ""
Write-Host "  Or use the management scripts:"
Write-Host "  .\docker-start.ps1 [command]"
Write-Host "  .\docker-start.bat [command]"
Write-Host ""

if ($ApiKey -eq "your_google_api_key_here") {
    Write-Warning "Remember to edit .env file and add your actual Google API key!"
    Write-Host "Edit with: notepad .env"
    Write-Host "Then restart with: docker-compose restart api"
}

Write-ColorText "Setup completed successfully! 🎉" "Green"
