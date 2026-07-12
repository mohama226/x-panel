from fastapi import FastAPI, Request, Form
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse


app = FastAPI(
    title="X-Panel",
    version="0.1"
)


templates = Jinja2Templates(
    directory="app/templates"
)


@app.get("/", response_class=HTMLResponse)
def index(request: Request):

    return templates.TemplateResponse(
        "index.html",
        {
            "request": request
        }
    )


@app.post("/login")
def login(
    username: str = Form(...),
    password: str = Form(...)
):

    return {
        "status": "ok",
        "username": username
    }
