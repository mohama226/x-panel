from fastapi import FastAPI, Request
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles

from pathlib import Path


BASE_DIR = Path(__file__).resolve().parent


app = FastAPI(
    title="X-PANEL",
    version="0.1"
)


templates = Jinja2Templates(
    directory=str(BASE_DIR / "templates")
)


@app.get("/")
async def home(request: Request):

    return templates.TemplateResponse(
        "index.html",
        {
            "request": request,
            "title": "X-PANEL"
        }
    )


@app.get("/status")
async def status():

    return {
        "panel": "x-panel",
        "status": "running",
        "version": "0.1"
    }
