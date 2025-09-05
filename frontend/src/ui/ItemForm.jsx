import React, { useState, useEffect } from 'react'
import API from "../api"; 


export default function ItemForm({ methods, onDone }){
const [methodId, setMethodId] = useState('')
const [categoryId, setCategoryId] = useState('')
const [title, setTitle] = useState('')
const [summary, setSummary] = useState('')
const [description, setDescription] = useState('')
const [file, setFile] = useState(null)
const [categories, setCategories] = useState([])
const [msg, setMsg] = useState('')


useEffect(()=>{
if(!methodId) return setCategories([])
const selected = methods.find(m=>m._id===methodId)
setCategories(selected?.categories || [])
}, [methodId, methods])


async function uploadFile(){
if(!file) return null
const fd = new FormData();
fd.append('file', file)
const res = await API.post('/api/upload/image', fd, { headers: { 'Content-Type': 'multipart/form-data' } })
return res.data
}


async function submit(e){
e.preventDefault()
try{
const uploaded = await uploadFile()
const images = uploaded ? [{ fileId: uploaded.fileId, filename: uploaded.filename }] : []
await API.post('/api/items', { categoryId, title, summary, description, images, linksTo: [] })
setMsg('Created')
setTitle(''); setSummary(''); setDescription(''); setFile(null)
onDone?.()
}catch(e){ setMsg(e.response?.data?.msg || 'Error creating item') }
}


return (
<form onSubmit={submit}>
<select required className="w-full p-2 border rounded mb-2" value={methodId} onChange={e=>setMethodId(e.target.value)}>
<option value="">Select method</option>
{methods.map(m=> <option key={m._id} value={m._id}>{m.name}</option>)}
</select>


<select required className="w-full p-2 border rounded mb-2" value={categoryId} onChange={e=>setCategoryId(e.target.value)}>
<option value="">Select category</option>
{categories.map(c=> <option key={c._id} value={c._id}>{c.name}</option>)}
</select>


<input required value={title} onChange={e=>setTitle(e.target.value)} placeholder="Title" className="w-full p-2 border rounded mb-2" />
<input value={summary} onChange={e=>setSummary(e.target.value)} placeholder="Summary" className="w-full p-2 border rounded mb-2" />
<textarea value={description} onChange={e=>setDescription(e.target.value)} placeholder="Description" className="w-full p-2 border rounded mb-2" />


<input type="file" onChange={e=>setFile(e.target.files[0])} className="mb-2" />


<button className="w-full bg-green-600 text-white p-2 rounded">Create Item</button>
{msg && <p className="mt-2">{msg}</p>}
</form>
)
}