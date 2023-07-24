
import { useState } from 'react';
import axios from "axios";
import "./FileUpload.css";
const FileUpload = ({contract,account,provider}) => {
  const [file, setFile] = useState(null);
  const [fileName, setFileName] = useState("No image selected");
// e.preventdefault reload hone se prevent krta hai
const handleSubmit= async(e)=>{
  e.preventDefault();
  if(file){
    try{
      const formData=new FormData();
      formData.append("file", file);
      const resFile = await axios({
        method: "post",
        url: "https://api.pinata.cloud/pinning/pinFileToIPFS",
        data: formData,
        maxBodyLength: "Infinity",
        headers: {
          pinata_api_key: `5bd19593d17f05385372`,
          pinata_secret_api_key: `fbc6dd393edcef2b3be3eced6ab75f573a68eb9e11bb7945a5f9a806ccb46012`,
          "Content-Type": "multipart/form-data",
        },
      });
      const ImgHash = `https://gateway.pinata.cloud/ipfs/${resFile.data.IpfsHash}`;
      contract.add(account,ImgHash);
      alert("Successfully Image Uploaded");
      setFileName("No image selected");
      setFile(null);
    }
    catch(e){
      alert("Unable to upload image");
    }
  }
  alert("Image Successfully Uploaded");
  setFileName("No image selected");
  setFile(null);

};
const retrieveFile=(e)=>{
  const data = e.target.files[0]; //files array of files object
     console.log(data);
    const reader = new window.FileReader();
    reader.readAsArrayBuffer(data);
    reader.onloadend = () => {
      setFile(e.target.files[0]);
    };
    setFileName(e.target.files[0].name);
    e.preventDefault();
};
  return (
    <div className="top">
    <form className="form" onSubmit={handleSubmit}>
      <label htmlFor="file-upload" className="choose">
        Choose Image
      </label>
      <input
        
        type="file"
        id="file-upload"
        name="data"
        onChange={retrieveFile}
      />
      <span className="textArea">Image: {fileName}</span>
      <button type="submit" className="upload" disabled={!file}>
        Upload
      </button>
    </form>
  </div>

  )
}

export default FileUpload