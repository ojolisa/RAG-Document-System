#!/usr/bin/env python3
"""
Test runner script for RAG application tests
"""

import sys
import subprocess
import os
from pathlib import Path

def run_command(cmd, description):
    """Run a command and handle output"""
    print(f"\n{'='*60}")
    print(f"Running: {description}")
    print(f"Command: {' '.join(cmd)}")
    print(f"{'='*60}")
    
    result = subprocess.run(cmd, capture_output=True, text=True)
    
    if result.stdout:
        print("STDOUT:")
        print(result.stdout)
    
    if result.stderr:
        print("STDERR:")
        print(result.stderr)
    
    if result.returncode != 0:
        print(f"❌ Failed with return code: {result.returncode}")
        return False
    else:
        print("✅ Success!")
        return True

def main():
    """Main test runner"""
    # Change to the RAG_app directory
    script_dir = Path(__file__).parent
    os.chdir(script_dir.parent)
    
    print("RAG Application Test Runner")
    print(f"Working directory: {os.getcwd()}")
    
    # Check if pytest is available
    try:
        subprocess.run([sys.executable, "-m", "pytest", "--version"], 
                      check=True, capture_output=True)
    except subprocess.CalledProcessError:
        print("❌ pytest not found. Installing test requirements...")
        if not run_command([sys.executable, "-m", "pip", "install", "-r", "tests/requirements-test.txt"],
                          "Installing test dependencies"):
            print("Failed to install test dependencies")
            return 1
    
    # Available test suites
    test_options = {
        "1": {
            "description": "Run all tests",
            "command": [sys.executable, "-m", "pytest", "tests/", "-v"]
        },
        "2": {
            "description": "Run unit tests only",
            "command": [sys.executable, "-m", "pytest", "tests/test_rag_pipeline.py", "tests/test_api.py", "-v"]
        },
        "3": {
            "description": "Run integration tests only", 
            "command": [sys.executable, "-m", "pytest", "tests/test_integration.py", "-v"]
        },
        "4": {
            "description": "Run document retrieval tests",
            "command": [sys.executable, "-m", "pytest", "tests/test_document_retrieval.py", "-v"]
        },
        "5": {
            "description": "Run tests with coverage",
            "command": [sys.executable, "-m", "pytest", "tests/", "--cov=api", "--cov=rag", "--cov-report=term-missing", "-v"]
        },
        "6": {
            "description": "Run quick tests (no slow tests)",
            "command": [sys.executable, "-m", "pytest", "tests/", "-v", "-m", "not slow"]
        }
    }
    
    # Interactive mode
    if len(sys.argv) == 1:
        print("\nAvailable test options:")
        for key, value in test_options.items():
            print(f"  {key}. {value['description']}")
        
        choice = input("\nSelect test option (1-6) or 'q' to quit: ").strip()
        
        if choice.lower() == 'q':
            print("Exiting...")
            return 0
        
        if choice not in test_options:
            print("Invalid choice!")
            return 1
        
        selected_test = test_options[choice]
        success = run_command(selected_test["command"], selected_test["description"])
        
    # Command line mode
    else:
        if sys.argv[1] == "all":
            success = run_command(test_options["1"]["command"], test_options["1"]["description"])
        elif sys.argv[1] == "unit":
            success = run_command(test_options["2"]["command"], test_options["2"]["description"])
        elif sys.argv[1] == "integration":
            success = run_command(test_options["3"]["command"], test_options["3"]["description"])
        elif sys.argv[1] == "retrieval":
            success = run_command(test_options["4"]["command"], test_options["4"]["description"])
        elif sys.argv[1] == "coverage":
            success = run_command(test_options["5"]["command"], test_options["5"]["description"])
        elif sys.argv[1] == "quick":
            success = run_command(test_options["6"]["command"], test_options["6"]["description"])
        else:
            print("Usage: python run_tests.py [all|unit|integration|retrieval|coverage|quick]")
            return 1
    
    return 0 if success else 1

if __name__ == "__main__":
    sys.exit(main())
