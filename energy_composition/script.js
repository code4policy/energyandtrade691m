
function showImage(imageSrc) {
    var img = document.getElementById('sector-image');
    img.src = imageSrc;
    img.style.display = 'block';
}

function downloadFile(filename) {
    const link = document.createElement('a');
    link.href = filename;
    link.download = filename;
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}

function downloadAllFiles() {
    const files = ['MER_T10_02A.csv', 'MER_T10_02B.csv', 'MER_T10_02C.csv'];
    files.forEach(file => downloadFile(file));
}

            
    
        
