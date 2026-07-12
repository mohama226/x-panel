from fastapi import FastAPI, Request
from fastapi.templating import Jinja2Templates

from pathlib import Path


BASE_DIR = Path(__file__).resolve().parent


app = FastAPI(
    title="X-PANEL"
)


templates = Jinja2Templates(
    directory=str(BASE_DIR / "templates")
)



@app.get("/")
async def index(request: Request):

    return templates.TemplateResponse(
        "index.html",
        {
            "request":request
        }
    )



@app.get("/api/status")
def status():

    return {
        "name":"x-panel",
        "status":"running",
        "version":"0.1"
    }
