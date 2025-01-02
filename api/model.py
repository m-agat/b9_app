from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse
from transformers import AutoImageProcessor, AutoModelForImageClassification
from PIL import Image
import torch
import io

# Load the model and processor
processor = AutoImageProcessor.from_pretrained("Anwarkh1/Skin_Cancer-Image_Classification")
model = AutoModelForImageClassification.from_pretrained("Anwarkh1/Skin_Cancer-Image_Classification")

app = FastAPI()

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    try:
        print(f"Received file: {file.filename}")

        # Load the image
        image = Image.open(io.BytesIO(await file.read()))

        # Preprocess the image
        inputs = processor(images=image, return_tensors="pt")

        # Make a prediction
        with torch.no_grad():
            outputs = model(**inputs)
            predictions = torch.nn.functional.softmax(outputs.logits, dim=-1)
            predicted_class = predictions.argmax().item()
            confidence = predictions.max().item()

        # Return the result
        return {"predicted_class": predicted_class, "confidence": confidence}
    except Exception as e:
        return JSONResponse(status_code=500, content={"error": str(e)})

@app.get("/")
def read_root():
    return {"message": "API is working!"}
