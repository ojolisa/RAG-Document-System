# 🐳 Docker Setup for RAG Document System

This directory contains a minimal Docker setup for the RAG Document System.

## Quick Start

1. **Copy environment file:**
   ```powershell
   copy .env.docker .env
   ```

2. **Edit the .env file with your Gemini API key:**
   ```env
   GEMINI_API_KEY=your_actual_gemini_api_key_here
   ```

3. **Run with Docker Compose:**
   ```powershell
   docker-compose up -d
   ```

4. **Access the application:**
   - API: http://localhost:8000
   - API Documentation: http://localhost:8000/docs
   - Health Check: http://localhost:8000/health

## Alternative Docker Commands

**Build and run manually:**
```powershell
# Build the image
docker build -t rag-app .

# Run the container
docker run -d -p 8000:8000 --env-file .env --name rag-container rag-app
```

**View logs:**
```powershell
docker-compose logs -f
```

**Stop the application:**
```powershell
docker-compose down
```

## Data Persistence

The setup includes volume mounts for:
- PDF files: `./rag/pdfs`
- FAISS index: `./rag/faiss_index.bin`
- Embeddings: `./rag/embeddings.pkl`
- Database: `./documents.db`

Your data will persist between container restarts.

## Notes

- The web frontend is not included in this Docker setup (API only)
- To use the frontend, access it directly at `frontend/index.html` in your browser
- Make sure to set your Gemini API key in the `.env` file before starting
