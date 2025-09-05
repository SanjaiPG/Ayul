# Siddha-Acupuncture Backend


## Quick start


1. Copy files locally into a directory named `backend`.
2. Create `.env` from `.env.example` and set `MONGO_URI` & `JWT_SECRET`.
3. `npm install`
4. `npm run dev` (requires nodemon) or `npm start`.


## Main endpoints


- `POST /api/auth/register` - register admin (email, password, name)
- `POST /api/auth/login` - login -> returns JWT
- `GET /api/methods` - list methods (with categories)
- `POST /api/methods` (admin) - create method
- `POST /api/categories` (admin) - create category under method
- `POST /api/items` (admin) - create item under category
- `GET /api/items/:id` - fetch item details (includes image URLs)
- `POST /api/upload/image` (admin) - upload image (multipart/form-data key: file)
- `GET /api/upload/files/:id` - download image by GridFS file id


## Notes
- Images are stored in MongoDB GridFS. In production you can swap to S3 and save URLs.
- Admin routes require `Authorization: Bearer <token>` header.