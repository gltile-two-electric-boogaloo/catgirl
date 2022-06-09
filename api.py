import fastapi
from fastapi.exceptions import HTTPException
from fastapi.middleware.cors import CORSMiddleware
import hypercorn.asyncio
import uvloop
import pydantic
import aiohttp
import os
import aioredis
import asyncio

app = fastapi.FastAPI()

origins = [os.environ['cors_origin']]

app.add_middleware(CORSMiddleware,
                   allow_origins=origins,
                   allow_credentials=False,
                   allow_methods=["*"],
                   allow_headers=["*"])
session: aiohttp.ClientSession
redis = aioredis.Redis(host=os.environ['redis_url'])
secret = os.environ['secret']
hostname = os.environ['host']


class Token(pydantic.BaseModel):
    token: str


@app.post("/api/v1/submit")
async def submit(token: Token):
    async with session.post(f"https://www.google.com/recaptcha/api/siteverify?secret={secret}&response={token.token}") as res:
        res = await res.json()

    if not res.get("success"):
        raise HTTPException(400, "bad token")

    if res.get("hostname") != hostname:
        print("hostname", res.get("hostname"))
        raise HTTPException(400, "bad hostname")

    if res.get("action") != "submit":
        raise HTTPException(400, "bad action")

    if res.get("score") < 0.3:
        raise HTTPException(403, f"we think you're a robot ({res.get('score')})")

    return await redis.incr("submitted")


@app.get("/api/v1/submit")
async def get_submit():
    return await redis.get("submitted")


async def get_session():
    global session
    session = aiohttp.ClientSession()


if __name__ == "__main__":
    config = hypercorn.config.Config()
    config.bind = [f"0.0.0.0:{os.environ.get('PORT', 8080)}"]

    if os.environ.get("DEV") == "1":
        config.use_reloader = True

    uvloop.install()
    asyncio.set_event_loop(asyncio.new_event_loop())
    asyncio.get_event_loop().run_until_complete(get_session())
    asyncio.get_event_loop().run_until_complete(hypercorn.asyncio.serve(app, config))  # noqa