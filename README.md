# 🤖 RAG Document System

A production-ready Retrieval-Augmented Generation (RAG) system that enables intelligent document search and AI-powered question answering. Upload PDF documents and query them using state-of-the-art AI models with a beautiful web interface.

## 🌟 Key Features

- **🚀 Production Ready**: Full Docker support with docker-compose
- **🎯 Smart Document Processing**: Advanced PDF parsing and intelligent text chunking
- **🔍 Vector Search**: Lightning-fast FAISS vector similarity search
- **🤖 AI-Powered**: Google Gemini 2.0 Flash for accurate response generation
- **🌐 Modern Web UI**: Beautiful, responsive interface with real-time updates
- **📊 RESTful API**: Complete FastAPI backend with automatic documentation
- **🧪 Comprehensive Testing**: Full test suite with unit, integration, and E2E tests
- **📱 Mobile Responsive**: Works seamlessly across all devices
- **🔒 Secure**: Environment-based configuration with API key management

## 📋 Table of Contents

- [Quick Start](#quick-start)
- [Docker Deployment](#docker-deployment)
- [Manual Installation](#manual-installation)
- [API Documentation](#api-documentation)
- [Web Interface](#web-interface)
- [Testing](#testing)
- [Configuration](#configuration)
- [Project Architecture](#project-architecture)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose (recommended)
- OR Python 3.8+ with pip
- Google Gemini API key ([Get one here](https://makersuite.google.com/app/apikey))

### Option 1: Docker Deployment (Recommended)

1. **Clone the repository**
```powershell
git clone <repository-url>
cd RAG-Document-System
```

2. **Set up environment**
```powershell
# Copy and edit the environment file
copy .env.example .env
# Edit .env and add your Gemini API key
```

3. **Launch with Docker**
```powershell
docker-compose up -d
```

4. **Access the application**
- **API**: http://localhost:8000
- **API Docs**: http://localhost:8000/docs
- **Web UI**: Open `frontend/index.html` in your browser

## 💻 Manual Installation

### Local Development Setup

For developers who prefer local installation without Docker:

#### Prerequisites
- **Python 3.8+**: [Download Python](https://www.python.org/downloads/)
- **Git**: [Download Git](https://git-scm.com/downloads)
- **Google Gemini API Key**: [Get API Key](https://makersuite.google.com/app/apikey)

#### Step-by-Step Installation

1. **Clone Repository**
```powershell
git clone <repository-url>
cd RAG-Document-System
```

2. **Create Virtual Environment**
```powershell
# Create virtual environment
python -m venv venv

# Activate virtual environment
venv\Scripts\activate

# Verify activation
where python  # Should point to venv directory
```

3. **Install Dependencies**
```powershell
# Upgrade pip
python -m pip install --upgrade pip

# Install main dependencies
pip install -r requirements.txt

# Install test dependencies (optional)
pip install -r tests\requirements-test.txt

# Verify installation
python -c "import fastapi, sentence_transformers, faiss; print('✅ Dependencies installed')"
```

4. **Environment Configuration**
```powershell
# Create environment file
echo GEMINI_API_KEY=your_actual_api_key_here > .env

# Verify environment
type .env
```

5. **Initialize Database**
```powershell
# The database will be created automatically on first run
# Optionally, you can pre-create it:
python -c "
from api.api import engine, Base
Base.metadata.create_all(bind=engine)
print('✅ Database initialized')
"
```

6. **Start Services**

**Option A: Integrated Startup**
```powershell
# Start API server (includes web interface)
cd api
python api.py
```

**Option B: Separate Services**
```powershell
# Terminal 1: Start API server
cd api
python api.py

# Terminal 2: Start frontend server (optional)
cd frontend
python server.py
```

7. **Verify Installation**
```powershell
# Test API health
curl http://localhost:8000/health

# Or using PowerShell
Invoke-RestMethod -Uri "http://localhost:8000/health"

# Expected response:
# {
#   "status": "healthy",
#   "rag_pipeline_loaded": true
# }
```

#### Access Points

- **🌐 Web Interface**: Open `frontend/index.html` in your browser
- **📚 API Documentation**: http://localhost:8000/docs
- **🔍 API Health Check**: http://localhost:8000/health
- **📊 ReDoc Documentation**: http://localhost:8000/redoc

### Development Tools Setup

#### IDE Configuration

**VS Code Extensions** (Recommended):
```json
{
  "recommendations": [
    "ms-python.python",
    "ms-python.black-formatter",
    "ms-python.pylint",
    "ms-python.isort",
    "humao.rest-client"
  ]
}
```

#### Testing Setup
```powershell
# Run all tests
python -m pytest tests/ -v

# Run with coverage
python -m pytest tests/ --cov=. --cov-report=html

# Run specific test categories
python -m pytest tests/ -m "unit" -v
python -m pytest tests/ -m "integration" -v
```

#### Debugging Configuration

**launch.json** for VS Code:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "FastAPI Debug",
      "type": "python",
      "request": "launch",
      "program": "api/api.py",
      "console": "integratedTerminal",
      "env": {
        "DEBUG": "true"
      }
    }
  ]
}
```

### Common Installation Issues

#### Python Version Issues
```powershell
# Check Python version
python --version  # Should be 3.8+

# If multiple Python versions
python3.11 -m venv venv  # Use specific version
```

#### Virtual Environment Issues
```powershell
# If activation fails
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Alternative activation
venv\Scripts\Activate.ps1
```

#### Dependency Conflicts
```powershell
# Clean install
pip uninstall -r requirements.txt -y
pip install -r requirements.txt --no-cache-dir
```

#### API Key Issues
```powershell
# Test API key
python -c "
import os
from dotenv import load_dotenv
load_dotenv()
key = os.getenv('GEMINI_API_KEY')
print(f'API Key: {key[:10]}...' if key else 'API Key not found')
"
```

## 🐳 Docker Deployment

### Production Deployment

```powershell
# Build and start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Rebuild after changes
docker-compose build --no-cache
```

### Docker Configuration

The Docker setup includes:
- **Persistent Storage**: Documents, embeddings, and database persist across restarts
- **Volume Mounts**: Direct access to uploaded PDFs and processed data
- **Environment Management**: Secure API key handling
- **Port Mapping**: API accessible on port 8000

### Environment Variables

```env
# Required
GEMINI_API_KEY=your_google_gemini_api_key

# Optional (with defaults)
API_HOST=0.0.0.0
API_PORT=8000
CHUNK_SIZE=512
CHUNK_OVERLAP=50
```

## 📱 Web Interface

The modern web interface provides an intuitive experience for document management and querying.

### Features
- **📄 Drag & Drop Upload**: Easy PDF document upload with progress indicators
- **📊 Document Management**: View, search, and delete uploaded documents
- **🔍 Intelligent Search**: Ask questions in natural language
- **📚 Source Attribution**: See exactly which document sections informed each answer
- **⚡ Real-time Updates**: Live connection status and instant results
- **📱 Mobile Responsive**: Works perfectly on all screen sizes

### Usage
1. Open `frontend/index.html` in your browser
2. Upload PDF documents using the upload section
3. Ask questions about your documents in the query section
4. View detailed responses with source citations
5. Manage your document library with the document list

### Interface Screenshots
- Clean, modern design with dark theme
- Color-coded responses and error handling
- Interactive document management with delete functionality
- Real-time API connection status indicator

## 📊 API Documentation

### Base URL
```
http://localhost:8000
```

### Interactive API Documentation
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

### Core Endpoints

#### Health Check
```http
GET /health
```
**Response:**
```json
{
  "status": "healthy",
  "rag_pipeline_loaded": true,
  "database_connected": true,
  "total_documents": 5
}
```

#### Document Upload
```http
POST /upload
Content-Type: multipart/form-data
```
**Parameters:**
- `file`: PDF file (required)

**Response:**
```json
{
  "message": "Document uploaded and processed successfully",
  "document_id": 1,
  "filename": "document.pdf",
  "original_name": "My Document.pdf",
  "chunks_created": 15,
  "file_size": 1024000,
  "status": "processed",
  "upload_date": "2025-06-06T10:30:00Z"
}
```

#### Query Documents
```http
POST /query
Content-Type: application/json
```
**Request Body:**
```json
{
  "question": "What is artificial intelligence?",
  "k": 5
}
```

**Response:**
```json
{
  "question": "What is artificial intelligence?",
  "answer": "Artificial intelligence (AI) refers to...",
  "sources": [
    {
      "filename": "ai_guide.pdf",
      "chunk_id": 1,
      "score": 0.8542,
      "content_preview": "AI is a branch of computer science..."
    }
  ],
  "processing_time": 1.23,
  "total_sources": 5
}
```

#### Document Management
```http
GET /documents?skip=0&limit=100     # List documents
GET /documents/{document_id}        # Get document details
DELETE /documents/{document_id}     # Delete document
```

### Python API Client

```python
from api.api_client import RAGAPIClient

# Initialize client
client = RAGAPIClient(base_url="http://localhost:8000")

# Upload document
result = client.upload_document("path/to/document.pdf")
print(f"Document ID: {result['document_id']}")

# Query documents
response = client.query_documents(
    question="What is machine learning?", 
    k=3
)
print(f"Answer: {response['answer']}")
print(f"Sources: {len(response['sources'])}")

# List documents
documents = client.get_documents()
for doc in documents['documents']:
    print(f"• {doc['original_name']} ({doc['total_chunks']} chunks)")

# Delete document
client.delete_document(document_id=1)
```

## 🧪 Testing

### Quick Test Execution

```powershell
# Run all tests
python -m pytest tests/ -v

# Run with coverage report
python -m pytest tests/ --cov=. --cov-report=html --cov-report=term

# Run specific test categories
python -m pytest tests/ -m "unit" -v          # Unit tests only
python -m pytest tests/ -m "integration" -v   # Integration tests only
```

### Test Categories

#### Unit Tests
- **API Tests**: `tests/test_api.py`
  - Endpoint validation
  - Request/response handling
  - Error scenarios
  - Authentication

- **RAG Pipeline Tests**: `tests/test_rag_pipeline.py`
  - Document processing
  - Embeddings generation
  - Vector search functionality
  - Response generation

#### Integration Tests
- **End-to-End Tests**: `tests/test_integration.py`
  - Complete workflow testing
  - API + RAG pipeline integration
  - Database interactions
  - File handling

- **Document Retrieval Tests**: `tests/test_document_retrieval.py`
  - Query accuracy
  - Source attribution
  - Similarity scoring
  - Performance benchmarks

### Test Configuration

```python
# tests/conftest.py
@pytest.fixture
def test_client():
    """FastAPI test client with test database"""
    return TestClient(app)

@pytest.fixture
def sample_pdf():
    """Sample PDF file for testing"""
    return "tests/fixtures/sample.pdf"
```

### Test Reports

Generate comprehensive test reports:

```powershell
# HTML coverage report
python -m pytest tests/ --cov=. --cov-report=html
# View at htmlcov/index.html

# XML coverage for CI/CD
python -m pytest tests/ --cov=. --cov-report=xml

# Performance profiling
python -m pytest tests/ --profile
```

## ⚙️ Configuration

### Environment Variables

```env
# Required
GEMINI_API_KEY=your_google_gemini_api_key_here

# Optional API Configuration
API_HOST=0.0.0.0
API_PORT=8000
DEBUG=false

# RAG Configuration
EMBEDDING_MODEL=all-MiniLM-L6-v2
CHUNK_SIZE=512
CHUNK_OVERLAP=50
MAX_TOKENS=2048

# Database Configuration
DATABASE_URL=sqlite:///./documents.db
POOL_SIZE=5
MAX_OVERFLOW=10

# CORS Configuration
ALLOWED_ORIGINS=http://localhost:3000,http://127.0.0.1:3000
```

### LLM Provider Configuration

#### Google Gemini (Default)
```python
# Current implementation uses Gemini 2.0 Flash
GEMINI_API_KEY=your_api_key_here
MODEL_NAME=models/gemini-2.0-flash
```

#### Adding Alternative Providers

```python
# Example configuration for multiple providers
class LLMConfig:
    def __init__(self):
        self.provider = os.getenv('LLM_PROVIDER', 'gemini')
        
        if self.provider == 'openai':
            self.api_key = os.getenv('OPENAI_API_KEY')
            self.model = os.getenv('OPENAI_MODEL', 'gpt-4')
        elif self.provider == 'anthropic':
            self.api_key = os.getenv('ANTHROPIC_API_KEY')
            self.model = os.getenv('ANTHROPIC_MODEL', 'claude-3-sonnet')
        else:  # default to gemini
            self.api_key = os.getenv('GEMINI_API_KEY')
            self.model = os.getenv('GEMINI_MODEL', 'models/gemini-2.0-flash')
```

### Advanced Configuration

#### Embedding Model Customization
```python
# In rag/rag_pipeline.py
EMBEDDING_MODELS = {
    'fast': 'all-MiniLM-L6-v2',
    'balanced': 'all-mpnet-base-v2',
    'accurate': 'sentence-transformers/all-MiniLM-L12-v2'
}

# Usage
embedding_model = os.getenv('EMBEDDING_MODEL', 'balanced')
```

#### Database Configuration
```python
# For PostgreSQL in production
DATABASE_URL = "postgresql://user:password@localhost/rag_documents"

# For SQLite (default)
DATABASE_URL = "sqlite:///./documents.db"
```

#### CORS and Security
```python
# In api/api.py
CORS_SETTINGS = {
    "allow_origins": os.getenv('ALLOWED_ORIGINS', '').split(','),
    "allow_credentials": True,
    "allow_methods": ["GET", "POST", "DELETE"],
    "allow_headers": ["*"],
}
```
```

## 🏗️ Project Architecture

### Directory Structure

```
RAG-Document-System/
├── 📁 api/                     # FastAPI Backend
│   ├── api.py                  # Main FastAPI application
│   ├── api_client.py           # Python client library
│   └── documents.db            # SQLite database
│
├── 📁 frontend/                # Web Interface
│   ├── index.html              # Single-page application
│   └── server.py               # Development server
│
├── 📁 rag/                     # RAG Processing Engine
│   ├── rag_pipeline.py         # Core RAG implementation
│   ├── simple_rag.py           # Simplified RAG version
│   ├── embeddings.pkl          # Cached document embeddings
│   ├── faiss_index.bin         # FAISS vector index
│   └── 📁 pdfs/                # Uploaded PDF storage
│
├── 📁 tests/                   # Comprehensive Test Suite
│   ├── test_api.py             # API endpoint tests
│   ├── test_rag_pipeline.py    # RAG functionality tests
│   ├── test_integration.py     # End-to-end tests
│   ├── test_document_retrieval.py # Query & retrieval tests
│   ├── conftest.py             # Test configuration
│   └── requirements-test.txt   # Test dependencies
│
├── 📁 Docker Configuration
│   ├── Dockerfile              # Container definition
│   ├── docker-compose.yml      # Multi-service orchestration
│   ├── docker-README.md        # Docker-specific documentation
│   └── .dockerignore           # Docker build exclusions
│
├── 📁 Configuration
│   ├── .env                    # Environment variables
│   ├── .gitignore             # Git exclusions
│   ├── requirements.txt        # Python dependencies
│   └── README.md              # This documentation
│
└── 📁 Data Persistence
    ├── documents.db           # Document metadata database
    ├── rag/embeddings.pkl     # Computed embeddings cache
    └── rag/faiss_index.bin    # Vector search index
```

### System Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   FastAPI       │    │   RAG Engine    │
│   (Web UI)      │◄──►│   Backend       │◄──►│   (Processing)  │
│                 │    │                 │    │                 │
│ • Document      │    │ • REST API      │    │ • PDF Parser    │
│   Upload        │    │ • CORS          │    │ • Text Chunking │
│ • Query Input   │    │ • File Handling │    │ • Embeddings    │
│ • Results       │    │ • Database      │    │ • Vector Search │
│   Display       │    │ • Error         │    │ • LLM Query     │
│ • Document      │    │   Handling      │    │ • Response Gen  │
│   Management    │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Browser       │    │   SQLAlchemy    │    │   External      │
│   Storage       │    │   Database      │    │   Services      │
│                 │    │                 │    │                 │
│ • Session       │    │ • Document      │    │ • Google        │
│   Management    │    │   Metadata      │    │   Gemini API    │
│ • Local         │    │ • Chunk Info    │    │ • Sentence      │
│   Caching       │    │ • File Paths    │    │   Transformers  │
│                 │    │ • Timestamps    │    │ • FAISS         │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Core Components

#### 1. FastAPI Backend (`api/`)
- **RESTful API**: Full CRUD operations for documents
- **File Upload**: Multipart form handling for PDF files
- **Database Integration**: SQLAlchemy ORM with SQLite
- **Error Handling**: Comprehensive exception management
- **CORS Support**: Cross-origin request handling
- **Auto Documentation**: Swagger/OpenAPI integration

#### 2. RAG Pipeline (`rag/`)
- **Document Processing**: PyPDF2-based PDF parsing
- **Text Chunking**: Intelligent text splitting with overlap
- **Embeddings**: Sentence Transformers for vector generation
- **Vector Storage**: FAISS for efficient similarity search
- **LLM Integration**: Google Gemini API for response generation
- **Caching**: Persistent storage of embeddings and indices

#### 3. Web Frontend (`frontend/`)
- **Modern UI**: Responsive design with CSS Grid/Flexbox
- **Real-time Updates**: Live API status and progress indicators
- **Document Management**: Upload, view, delete functionality
- **Query Interface**: Natural language question input
- **Results Display**: Formatted answers with source attribution
- **Mobile Support**: Touch-friendly responsive design

#### 4. Database Schema

```sql
-- Document metadata table
CREATE TABLE documents (
    id INTEGER PRIMARY KEY,
    filename VARCHAR UNIQUE,
    original_name VARCHAR,
    file_path VARCHAR,
    file_size INTEGER,
    upload_date DATETIME,
    status VARCHAR,
    total_chunks INTEGER,
    processing_time FLOAT
);

-- Document chunks table
CREATE TABLE chunks (
    id INTEGER PRIMARY KEY,
    document_id INTEGER,
    chunk_index INTEGER,
    content TEXT,
    embedding_vector BLOB,
    FOREIGN KEY (document_id) REFERENCES documents(id)
);
```

### Data Flow

1. **Document Upload**
   ```
   PDF File → FastAPI → File Storage → RAG Pipeline → 
   Text Extraction → Chunking → Embeddings → FAISS Index → Database
   ```

2. **Query Processing**
   ```
   User Query → FastAPI → RAG Pipeline → Query Embedding → 
   FAISS Search → Context Retrieval → LLM Generation → Response
   ```

3. **Document Management**
   ```
   User Action → FastAPI → Database Query → File System → 
   Index Update → Response
   ```

## 🔧 Troubleshooting

### Common Issues & Solutions

#### 🔌 Connection Issues

**Problem**: API connection failed
```bash
# Check if API is running
curl http://localhost:8000/health

# Or use PowerShell
Invoke-RestMethod -Uri "http://localhost:8000/health"
```

**Solution**:
```powershell
# Restart API server
docker-compose restart rag-api

# Or for local development
cd api && python api.py
```

#### 🔑 API Key Issues

**Problem**: Gemini API key not working
```json
{"detail": "API key not configured or invalid"}
```

**Solutions**:
```powershell
# Check environment file
type .env

# Verify API key format (should start with 'AIza')
echo $env:GEMINI_API_KEY

# Test API key directly
curl -H "x-goog-api-key: YOUR_API_KEY" \
  "https://generativelanguage.googleapis.com/v1beta/models"
```

#### 🐳 Docker Issues

**Problem**: Docker container won't start
```powershell
# Check container logs
docker-compose logs rag-api

# Check port conflicts
netstat -ano | findstr :8000

# Rebuild containers
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

**Problem**: Volume mounting issues
```powershell
# Check volume permissions
docker-compose exec rag-api ls -la /app/rag/pdfs

# Reset volumes
docker-compose down -v
docker-compose up -d
```

#### 📚 Database Issues

**Problem**: Database corruption or missing
```powershell
# Backup existing database
copy documents.db documents.db.backup

# Reset database (will lose data)
del documents.db
# Restart application to recreate

# Check database integrity
sqlite3 documents.db "PRAGMA integrity_check;"
```

#### 📄 PDF Processing Issues

**Problem**: PDF upload fails
```json
{"detail": "Error processing PDF: [specific error]"}
```

**Solutions**:
- **Password-protected PDFs**: Remove password protection
- **Corrupted PDFs**: Try re-downloading or use PDF repair tools
- **Large files**: Check file size limits (default: 50MB)
- **Non-text PDFs**: Ensure PDFs contain extractable text

```powershell
# Test PDF text extraction
python -c "
import PyPDF2
with open('your_file.pdf', 'rb') as f:
    reader = PyPDF2.PdfReader(f)
    print(f'Pages: {len(reader.pages)}')
    print(f'First page text: {reader.pages[0].extract_text()[:200]}')
"
```

#### 🧠 Memory Issues

**Problem**: Out of memory during processing
```bash
# Monitor memory usage
docker stats rag-api

# Or on Windows
tasklist | findstr python
```

**Solutions**:
```powershell
# Increase Docker memory limits
# Edit docker-compose.yml:
services:
  rag-api:
    deploy:
      resources:
        limits:
          memory: 4G

# Reduce chunk size for large documents
# Edit .env:
CHUNK_SIZE=256
CHUNK_OVERLAP=25
```

#### 🔍 Search Quality Issues

**Problem**: Poor search results or irrelevant answers

**Solutions**:
```env
# Adjust similarity threshold
MIN_SIMILARITY_SCORE=0.7

# Increase number of retrieved documents
DEFAULT_K=10

# Try different embedding model
EMBEDDING_MODEL=all-mpnet-base-v2
```

### Performance Optimization

#### 🚀 Speed Improvements

```powershell
# Use GPU acceleration (if available)
pip install faiss-gpu

# Enable model caching
# Add to .env:
HF_HOME=./cache/huggingface
TRANSFORMERS_CACHE=./cache/transformers
```

#### 📊 Monitoring & Debugging

```powershell
# Enable debug logging
# Add to .env:
DEBUG=true
LOG_LEVEL=DEBUG

# Monitor API performance
curl -w "@curl-format.txt" -s -o /dev/null http://localhost:8000/health

# Check embedding generation time
python -c "
from rag.rag_pipeline import RAGPipeline
import time
rag = RAGPipeline()
start = time.time()
emb = rag.embedder.encode(['test text'])
print(f'Embedding time: {time.time() - start:.3f}s')
"
```

### Health Checks

#### 🏥 System Health Verification

```powershell
# Complete system check
function Test-RAGSystem {
    # API Health
    $health = Invoke-RestMethod "http://localhost:8000/health"
    Write-Host "API Status: $($health.status)"
    
    # Database check
    $docs = Invoke-RestMethod "http://localhost:8000/documents"
    Write-Host "Documents: $($docs.total_count)"
    
    # Test query
    $query = @{question="test"; k=1} | ConvertTo-Json
    $result = Invoke-RestMethod -Uri "http://localhost:8000/query" -Method POST -Body $query -ContentType "application/json"
    Write-Host "Query test: $($result.answer.Length -gt 0)"
}

Test-RAGSystem
```

### Getting Help

#### 📞 Support Channels

1. **Check Documentation**: Review this README and API docs at `/docs`
2. **Search Issues**: Look for similar problems in project issues
3. **Enable Debug Mode**: Set `DEBUG=true` for detailed logs
4. **Provide Context**: Include logs, environment details, and steps to reproduce

#### 🐛 Bug Reports

Include in your bug report:
- Operating system and version
- Python version (`python --version`)
- Docker version (if using Docker)
- Complete error logs
- Steps to reproduce the issue
- Expected vs actual behavior

```powershell
# Collect system information
python --version
docker --version
pip list | grep -E "(fastapi|sentence-transformers|faiss|google-generativeai)"
```

## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

### Development Setup

```powershell
# Fork and clone the repository
git clone https://github.com/your-username/RAG-Document-System.git
cd RAG-Document-System

# Create development environment
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
pip install -r tests\requirements-test.txt

# Set up pre-commit hooks
pip install pre-commit
pre-commit install
```

### Development Workflow

1. **Create Feature Branch**
```powershell
git checkout -b feature/your-feature-name
```

2. **Make Changes**
   - Follow existing code style and patterns
   - Add docstrings for new functions
   - Update type hints where applicable

3. **Add Tests**
```powershell
# Create tests for new functionality
# tests/test_your_feature.py

# Run tests locally
python -m pytest tests/ -v
python -m pytest tests/ --cov=. --cov-report=term
```

4. **Update Documentation**
   - Update README.md if needed
   - Add docstrings to new functions
   - Update API documentation

5. **Commit Changes**
```powershell
git add .
git commit -m "feat: add your feature description"
git push origin feature/your-feature-name
```

### Code Style Guidelines

- **Python**: Follow PEP 8 style guide
- **Docstrings**: Use Google-style docstrings
- **Type Hints**: Include type hints for function parameters and returns
- **Error Handling**: Use appropriate exception handling
- **Logging**: Use structured logging with appropriate levels

### Pull Request Guidelines

- Provide clear description of changes
- Include screenshots for UI changes
- Reference related issues
- Ensure all tests pass
- Update documentation as needed

## 📚 Additional Resources

### Learning Materials

- **RAG Concepts**: [Retrieval-Augmented Generation Paper](https://arxiv.org/abs/2005.11401)
- **FastAPI Docs**: [Official FastAPI Documentation](https://fastapi.tiangolo.com/)
- **FAISS Tutorial**: [Facebook AI Similarity Search](https://github.com/facebookresearch/faiss)
- **Sentence Transformers**: [Hugging Face Documentation](https://www.sbert.net/)

### Related Projects

- **LangChain**: Advanced RAG implementations
- **ChromaDB**: Alternative vector database
- **Pinecone**: Managed vector database service
- **Weaviate**: Open-source vector database

### Performance Benchmarks

| Component | Metric | Performance |
|-----------|--------|-------------|
| PDF Processing | Pages/second | ~10-15 pages/sec |
| Embedding Generation | Docs/second | ~5-10 docs/sec |
| Vector Search | Queries/second | ~100-500 QPS |
| End-to-End Query | Response Time | ~1-3 seconds |

*Results may vary based on hardware and document complexity*

## 🆘 Support & Community

### Getting Help

1. **📖 Documentation**: Check this README and API docs at `/docs`
2. **🔍 Search Issues**: Look for existing solutions in GitHub issues
3. **🐛 Bug Reports**: Create detailed issue reports with reproduction steps
4. **💡 Feature Requests**: Suggest improvements via GitHub issues

### Community Guidelines

- Be respectful and constructive
- Provide clear, reproducible examples
- Help others when possible
- Follow the code of conduct

### Roadmap

#### Upcoming Features
- [ ] **Multi-format Support**: Word, Excel, PowerPoint document processing
- [ ] **Advanced Search**: Semantic search with metadata filtering
- [ ] **User Authentication**: Multi-user support with access controls
- [ ] **Cloud Storage**: S3, Azure Blob, Google Cloud integration
- [ ] **API Rate Limiting**: Production-ready rate limiting
- [ ] **Monitoring Dashboard**: Real-time system metrics

#### Future Enhancements
- [ ] **Graph RAG**: Knowledge graph integration
- [ ] **Multi-modal RAG**: Image and table processing
- [ ] **Advanced Chunking**: Semantic and hierarchical chunking
- [ ] **Query Optimization**: Intent recognition and query rewriting
- [ ] **Feedback Loop**: User rating and model improvement

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Google AI**: For the Gemini API
- **Facebook Research**: For FAISS vector search
- **Hugging Face**: For Sentence Transformers
- **FastAPI Team**: For the excellent web framework
- **Open Source Community**: For the amazing tools and libraries

---

## 📊 Quick Reference

### Essential Commands

```powershell
# Development
docker-compose up -d              # Start all services
python -m pytest tests/ -v       # Run tests
python api\api.py                 # Start API server

# Maintenance
docker-compose logs -f            # View logs
docker system prune -f           # Clean Docker cache
pip install -r requirements.txt  # Update dependencies

# Debugging
curl http://localhost:8000/health # Check API health
python -c "from rag.rag_pipeline import RAGPipeline; print('✅ RAG OK')"
```

### Key Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/health` | GET | System health check |
| `/upload` | POST | Upload PDF document |
| `/query` | POST | Query documents |
| `/documents` | GET | List all documents |
| `/documents/{id}` | DELETE | Delete document |
| `/docs` | GET | API documentation |

### Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `GEMINI_API_KEY` | ✅ | - | Google Gemini API key |
| `API_PORT` | ❌ | 8000 | API server port |
| `CHUNK_SIZE` | ❌ | 512 | Text chunk size |
| `CHUNK_OVERLAP` | ❌ | 50 | Chunk overlap |
| `DEBUG` | ❌ | false | Enable debug logging |

---

**🚀 Ready to build amazing AI-powered document systems? Let's go!**

*Last updated: June 6, 2025*
