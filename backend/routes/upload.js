const express = require('express');
const router = express.Router();
const multer = require('multer');
const { GridFsStorage } = require('multer-gridfs-storage');
const mongoose = require('mongoose');
const auth = require('../middleware/auth');


// configure storage - uses MONGO_URI from env
const storage = new GridFsStorage({
url: process.env.MONGO_URI,
options: { useNewUrlParser: true, useUnifiedTopology: true },
file: (req, file) => {
return {
filename: `${Date.now()}-${file.originalname}`,
bucketName: 'uploads' // collection name in GridFS
};
}
});


const upload = multer({ storage });


// upload image (admin)
router.post('/image', auth, upload.single('file'), (req, res) => {
// multer-gridfs-storage attaches file info to req.file
if (!req.file) return res.status(400).json({ msg: 'No file uploaded' });
return res.json({ fileId: req.file.id, filename: req.file.filename });
});


// download file by id
router.get('/files/:id', async (req, res) => {
try {
const conn = mongoose.connection;
const bucket = new mongoose.mongo.GridFSBucket(conn.db, { bucketName: 'uploads' });
const id = new mongoose.Types.ObjectId(req.params.id);
const files = await conn.db.collection('uploads.files').find({ _id: id }).toArray();
if (!files || files.length === 0) return res.status(404).json({ msg: 'File not found' });
const file = files[0];
res.set('Content-Type', file.contentType || 'application/octet-stream');
const downloadStream = bucket.openDownloadStream(id);
downloadStream.on('error', (err) => {
console.error('Download stream error', err);
res.sendStatus(404);
});
downloadStream.pipe(res);
} catch (err) {
console.error(err);
res.status(400).json({ msg: 'Invalid file id' });
}
});


module.exports = router;