# RAG Application - Docker Setup

This Docker Compose setup provides a complete containerized environment for the RAG (Retrieval-Augmented Generation) document system.

## Services

- **API Service**: FastAPI backend running on port 8000
- **Frontend Service**: Simple HTTP server running on port 3000

## Prerequisites

1. Docker and Docker Compose installed
2. Google Gemini API key (for the RAG functionality)

## Quick Start

1. **Clone/Setup the project**:
   ```bash
   # Ensure you're in the RAG_app directory
   cd c:\Work\Intern\panscience\RAG_app
   ```

2. **Set up environment variables**:
   ```bash
   # Copy the example environment file
   copy .env.example .env
   
   # Edit .env and add your Google API key
   # GOOGLE_API_KEY=your_actual_api_key_here
   ```

3. **Build and start the services**:
   ```bash
   docker-compose up --build
   ```

4. **Access the application**:
   - Frontend: http://localhost:3000
   - API: http://localhost:8000
   - API Documentation: http://localhost:8000/docs

## Development Mode

To run in development mode with auto-reload:

```bash
docker-compose up --build --watch
```

## Stopping the Services

```bash
# Stop services
docker-compose down

# Stop and remove volumes (this will delete uploaded files and database)
docker-compose down -v
```

## Data Persistence

The following data is persisted using Docker volumes and bind mounts:

- **Database**: `api/documents.db` - SQLite database with document metadata
- **PDFs**: `rag/pdfs/` - Uploaded PDF documents
- **Embeddings**: `rag/embeddings.pkl` - Pre-computed embeddings
- **FAISS Index**: `rag/faiss_index.bin` - Vector search index

## Environment Variables

Create a `.env` file with the following variables:

```env
GOOGLE_API_KEY=your_google_gemini_api_key
SQLALCHEMY_DATABASE_URL=sqlite:///./documents.db
PYTHONPATH=/app
API_HOST=0.0.0.0
API_PORT=8000
FRONTEND_PORT=3000
```

## Troubleshooting

### Service Health Checks

The API service includes health checks. You can check service status:

```bash
docker-compose ps
```

### View Logs

```bash
# View all logs
docker-compose logs

# View specific service logs
docker-compose logs api
docker-compose logs frontend

# Follow logs in real-time
docker-compose logs -f
```

### Rebuild Services

If you make changes to the code:

```bash
# Rebuild specific service
docker-compose build api
docker-compose build frontend

# Rebuild and restart
docker-compose up --build
```

### Access Container Shell

```bash
# Access API container
docker-compose exec api bash

# Access Frontend container
docker-compose exec frontend bash
```

## Production Deployment

For production deployment, consider:

1. **Use a reverse proxy** (nginx) for SSL and better performance
2. **Use a proper database** (PostgreSQL) instead of SQLite
3. **Add authentication and authorization**
4. **Set up proper logging and monitoring**
5. **Use Docker secrets** for sensitive data
6. **Configure resource limits**

Example production docker-compose.override.yml:

```yaml
version: '3.8'
services:
  api:
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
    restart: unless-stopped
    
  frontend:
    deploy:
      resources:
        limits:
          memory: 512M
          cpus: '0.5'
    restart: unless-stopped
```

## API Endpoints

Once running, the API provides these endpoints:

- `GET /health` - Health check
- `POST /upload` - Upload PDF documents
- `POST /query` - Query documents using RAG
- `GET /documents` - List uploaded documents
- `DELETE /documents/{doc_id}` - Delete a document
- `GET /docs` - Interactive API documentation

## Architecture

```
┌─────────────┐     ┌─────────────┐
│  Frontend   │────▶│     API     │
│  (Port 3000)│     │ (Port 8000) │
└─────────────┘     └─────────────┘
                           │
                    ┌─────────────┐
                    │   Storage   │
                    │ - SQLite DB │
                    │ - PDF files │
                    │ - Embeddings│
                    │ - FAISS idx │
                    └─────────────┘
```

## Support

If you encounter issues:

1. Check the logs using `docker-compose logs`
2. Ensure all environment variables are set correctly
3. Verify your Google API key is valid
4. Make sure ports 3000 and 8000 are not in use by other applications
