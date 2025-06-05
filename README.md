# 🤖 RAG Document System

A modern Retrieval-Augmented Generation (RAG) system that allows you to upload PDF documents and query them using AI-powered search. Built with FastAPI, Sentence Transformers, FAISS, and Google's Gemini API.

## 📋 Table of Contents

- [Features](#features)
- [Setup and Installation](#setup-and-installation)
- [API Usage](#api-usage)
- [Testing Guidelines](#testing-guidelines)
- [Configuration](#configuration)
- [Project Structure](#project-structure)
- [Troubleshooting](#troubleshooting)

## ✨ Features

- **Document Upload**: Upload PDF documents for processing
- **Intelligent Chunking**: Automatically splits documents into semantic chunks
- **Vector Search**: Uses FAISS for fast similarity search
- **AI-Powered Responses**: Leverages Google Gemini API for response generation
- **REST API**: Complete RESTful API for integration
- **Web Interface**: Beautiful modern web UI for easy interaction
- **Document Management**: View, delete, and manage uploaded documents
- **Real-time Processing**: Immediate document processing and indexing

## 🚀 Setup and Installation

### Prerequisites

- Python 3.8 or higher
- pip (Python package installer)
- A Google Gemini API key

### Step 1: Clone/Download the Project

```powershell
# Navigate to your desired directory
cd c:\Work\Intern\panscience\RAG_app
```

### Step 2: Create Virtual Environment

```powershell
# Create virtual environment
python -m venv venv

# Activate virtual environment (Windows)
venv\Scripts\activate
```

### Step 3: Install Dependencies

```powershell
# Install main dependencies
pip install -r requirements.txt

# Install test dependencies (optional)
pip install -r tests\requirements-test.txt
```

### Step 4: Environment Configuration

Create a `.env` file in the root directory:

```env
# .env file
GEMINI_API_KEY=your_gemini_api_key_here
```

To get a Gemini API key:
1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create a new API key
3. Copy the key to your `.env` file

### Step 5: Start the Application

#### Option A: Use the Startup Script (Recommended)
```powershell
start_app.bat
```

#### Option B: Manual Startup
```powershell
# Start API server
cd api
python api.py

# In another terminal, start frontend server
cd frontend
python server.py
```

### Step 6: Access the Application

- **Web Interface**: http://localhost:3000
- **API Documentation**: http://localhost:8000/docs
- **API Health Check**: http://localhost:8000/health

## 📊 API Usage

### Base URL
```
http://localhost:8000
```

### Available Endpoints

#### 1. Health Check
```http
GET /health
```
**Response:**
```json
{
  "status": "healthy",
  "rag_pipeline_loaded": true
}
```

#### 2. Upload Document
```http
POST /upload
Content-Type: multipart/form-data

file: [PDF file]
```
**Response:**
```json
{
  "message": "Document uploaded and processed successfully",
  "document_id": 1,
  "filename": "document.pdf",
  "chunks_created": 15,
  "status": "processed"
}
```

#### 3. Query Documents
```http
POST /query
Content-Type: application/json

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
      "score": 0.85,
      "content_preview": "AI is a branch of computer science..."
    }
  ],
  "processing_time": 1.23
}
```

#### 4. Get Documents List
```http
GET /documents?skip=0&limit=100
```

#### 5. Get Document Details
```http
GET /documents/{document_id}
```

#### 6. Delete Document
```http
DELETE /documents/{document_id}
```

### Using the API Client

The project includes a Python API client for easy integration:

```python
from api.api_client import RAGAPIClient

# Initialize client
client = RAGAPIClient()

# Upload document
result = client.upload_document("path/to/document.pdf")
print(f"Document uploaded: {result['document_id']}")

# Query documents
response = client.query_documents("What is machine learning?", k=3)
print(f"Answer: {response['answer']}")

# Get documents list
documents = client.get_documents()
print(f"Total documents: {documents['total_count']}")
```

## 🧪 Testing Guidelines

### Running Tests

#### Quick Test Run
```powershell
run_tests.bat
# Or manually:
python -m pytest tests/ -v
```

#### Test Categories

1. **Unit Tests**
```powershell
python -m pytest tests/test_rag_pipeline.py tests/test_api.py -v
```

2. **Integration Tests**
```powershell
python -m pytest tests/test_integration.py -v
```

3. **Document Retrieval Tests**
```powershell
python -m pytest tests/test_document_retrieval.py -v
```

4. **Coverage Report**
```powershell
python -m pytest tests/ --cov=. --cov-report=html
```

### Test Structure

- `tests/test_api.py` - API endpoint tests
- `tests/test_rag_pipeline.py` - Core RAG functionality tests
- `tests/test_integration.py` - End-to-end integration tests
- `tests/test_document_retrieval.py` - Document retrieval and query tests
- `tests/conftest.py` - Test configuration and fixtures

### Test Requirements

```powershell
# Install test dependencies
pip install -r tests/requirements-test.txt
```

## ⚙️ Configuration

### LLM Provider Configuration

The system currently supports Google Gemini API. To configure different LLM providers:

#### Current Configuration (Google Gemini)
```python
# In rag/rag_pipeline.py
import google.generativeai as genai

# Configure API
api_key = os.getenv('GEMINI_API_KEY')
genai.configure(api_key=api_key)
self.model = genai.GenerativeModel('models/gemini-2.0-flash')
```

#### Environment Variables
```env
# Required for Google Gemini
GEMINI_API_KEY=your_gemini_api_key_here

# Alternative names (for compatibility)
GOOGLE_API_KEY=your_gemini_api_key_here
```

#### Adding Other LLM Providers

To add support for other LLM providers (OpenAI, Anthropic, etc.), modify the `RAGPipeline` class:

```python
# Example for OpenAI
import openai

class RAGPipeline:
    def __init__(self, ...):
        # Add provider selection
        self.llm_provider = os.getenv('LLM_PROVIDER', 'gemini')
        
        if self.llm_provider == 'openai':
            openai.api_key = os.getenv('OPENAI_API_KEY')
        elif self.llm_provider == 'gemini':
            # Current Gemini setup
            pass
    
    def generate_response(self, query: str, context_docs: List[Dict]) -> str:
        if self.llm_provider == 'openai':
            # OpenAI implementation
            pass
        elif self.llm_provider == 'gemini':
            # Current Gemini implementation
            pass
```

### Other Configuration Options

#### Embedding Model
```python
# In rag/rag_pipeline.py
self.embedder = SentenceTransformer('all-MiniLM-L6-v2')
```

#### Chunk Size and Overlap
```python
def chunk_text(self, text: str, chunk_size: int = 512, overlap: int = 50):
```

#### Database Configuration
```python
# In api/api.py
SQLALCHEMY_DATABASE_URL = "sqlite:///./documents.db"
```

#### CORS Configuration
```python
# In api/api.py
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000", "http://127.0.0.1:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

## 📁 Project Structure

```
RAG_app/
├── api/                    # API server components
│   ├── api.py             # FastAPI application
│   ├── api_client.py      # Python API client
│   └── start_api.bat      # API startup script
├── frontend/              # Web interface
│   ├── index.html         # Main web interface
│   ├── server.py          # Frontend server
│   └── start_frontend.bat # Frontend startup script
├── rag/                   # RAG pipeline components
│   ├── rag_pipeline.py    # Core RAG implementation
│   ├── simple_rag.py      # Simplified RAG version
│   ├── pdfs/              # PDF storage directory
│   ├── faiss_index.bin    # FAISS vector index
│   └── embeddings.pkl     # Cached embeddings
├── tests/                 # Test suite
│   ├── test_api.py        # API tests
│   ├── test_rag_pipeline.py # RAG tests
│   ├── test_integration.py # Integration tests
│   ├── test_document_retrieval.py # Retrieval tests
│   ├── conftest.py        # Test configuration
│   └── requirements-test.txt # Test dependencies
├── requirements.txt       # Main dependencies
├── start_app.bat         # Application startup script
├── run_tests.bat         # Test runner script
├── .env                  # Environment variables (create this)
└── README.md             # This file
```

## 🔧 Troubleshooting

### Common Issues

#### 1. Virtual Environment Not Found
```powershell
# Error: Virtual environment not found
# Solution: Create virtual environment
python -m venv venv
venv\Scripts\activate
```

#### 2. Missing Dependencies
```powershell
# Error: ModuleNotFoundError
# Solution: Install dependencies
pip install -r requirements.txt
```

#### 3. Gemini API Key Issues
```powershell
# Error: API key not configured
# Solution: Check .env file
echo GEMINI_API_KEY=your_key_here > .env
```

#### 4. Port Already in Use
```powershell
# Error: Port 8000 or 3000 already in use
# Solution: Kill existing processes or change ports

# Check what's using the port
netstat -ano | findstr :8000

# Kill process by PID
taskkill /F /PID <process_id>
```

#### 5. FAISS Index Issues
```powershell
# Error: FAISS index corrupted
# Solution: Delete and rebuild index
del rag\faiss_index.bin
del rag\embeddings.pkl
# Restart application to rebuild
```

#### 6. PDF Processing Errors
```powershell
# Error: Unable to process PDF
# Solutions:
# 1. Ensure PDF is not password protected
# 2. Check PDF file size (very large files may timeout)
# 3. Verify PDF is not corrupted
```

### Performance Optimization

#### 1. Large Document Collections
- Consider using a more powerful embedding model
- Increase chunk overlap for better context
- Use GPU acceleration for embeddings if available

#### 2. Query Response Time
- Reduce the value of `k` (number of retrieved documents)
- Optimize chunk size based on your documents
- Consider caching frequent queries

#### 3. Memory Usage
- Monitor memory usage with large document collections
- Consider implementing document pagination
- Use database cleanup for old documents

### Logs and Debugging

#### Enable Debug Logging
```python
# Add to api/api.py
import logging
logging.basicConfig(level=logging.DEBUG)
```

#### Check API Health
```powershell
curl http://localhost:8000/health
```

#### View Documents in Database
```python
# Quick database check
import sqlite3
conn = sqlite3.connect('documents.db')
cursor = conn.cursor()
cursor.execute('SELECT * FROM documents')
print(cursor.fetchall())
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Run the test suite
6. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

If you encounter any issues or have questions:

1. Check the troubleshooting section above
2. Review the test suite for usage examples
3. Check the API documentation at http://localhost:8000/docs
4. Create an issue in the project repository

---

**Happy querying! 🚀**
