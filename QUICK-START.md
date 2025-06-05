# RAG Application - Quick Start with Docker

## 🚀 Quick Setup (Recommended)

1. **Run the automated setup script**:
   ```powershell
   .\setup-docker.ps1
   ```
   
   Or for development mode:
   ```powershell
   .\setup-docker.ps1 -Development
   ```

2. **Access your application**:
   - Frontend: http://localhost:3000
   - API: http://localhost:8000
   - API Docs: http://localhost:8000/docs

## 📋 Manual Setup

If you prefer manual setup:

1. **Create environment file**:
   ```powershell
   Copy-Item .env.example .env
   # Edit .env and add your Google API key
   ```

2. **Start services**:
   ```powershell
   docker-compose up --build -d
   ```

## 🛠️ Management Commands

Use the management scripts for easy control:

### PowerShell (Recommended)
```powershell
.\docker-start.ps1 start      # Start all services
.\docker-start.ps1 dev        # Development mode with hot reload
.\docker-start.ps1 stop       # Stop services
.\docker-start.ps1 logs       # View logs
.\docker-start.ps1 status     # Check service status
.\docker-start.ps1 clean      # Clean up everything
```

### Command Prompt
```cmd
docker-start.bat start        # Start all services
docker-start.bat dev          # Development mode
docker-start.bat stop         # Stop services
docker-start.bat logs         # View logs
```

### Direct Docker Compose
```powershell
# Basic operations
docker-compose up --build -d         # Start services
docker-compose down                   # Stop services
docker-compose logs -f                # View logs
docker-compose ps                     # Check status

# Development mode
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up --build

# Production mode
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up --build -d
```

## 🔧 Configuration

### Environment Variables (.env file)
```env
GOOGLE_API_KEY=your_actual_api_key_here
SQLALCHEMY_DATABASE_URL=sqlite:///./documents.db
PYTHONPATH=/app
API_HOST=0.0.0.0
API_PORT=8000
FRONTEND_PORT=3000
```

### Required Setup
- **Google Gemini API Key**: Get from https://aistudio.google.com/app/apikey
- **Docker Desktop**: Install from https://www.docker.com/products/docker-desktop

## 📁 Data Persistence

Your data is automatically persisted:
- **Database**: `api/documents.db`
- **PDF Files**: `rag/pdfs/`
- **Embeddings**: `rag/embeddings.pkl`
- **Search Index**: `rag/faiss_index.bin`

## 🐛 Troubleshooting

### Check Service Status
```powershell
docker-compose ps
```

### View Logs
```powershell
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f api
docker-compose logs -f frontend
```

### Restart Services
```powershell
docker-compose restart
```

### Complete Reset (⚠️ Deletes all data)
```powershell
.\docker-start.ps1 clean
```

## 🌐 URLs After Setup

- **Frontend Application**: http://localhost:3000
- **API Endpoint**: http://localhost:8000
- **Interactive API Docs**: http://localhost:8000/docs
- **Health Check**: http://localhost:8000/health

## 💡 Tips

1. **First Time Setup**: Use `.\setup-docker.ps1` for automated setup
2. **Development**: Use `.\docker-start.ps1 dev` for hot reload
3. **Production**: Use `.\docker-start.ps1 -Production` flag in setup
4. **API Key**: Remember to set your Google API key in `.env`
5. **Large Files**: PDF uploads up to 100MB are supported

---

**Need help?** Check the full documentation in `Docker-README.md`
