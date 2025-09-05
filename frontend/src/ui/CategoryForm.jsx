import React, { useState } from 'react'
import API from '../api'


export default function CategoryForm({ methods, onDone }){
const [methodId, setMethodId] = useState('')
const [name, setName] = useState('')
const [msg, setMsg] = useState('')


async function submit(e){
e.preventDefault()
try{
await API.post('/api/categories', { traditionalMethodId: methodId, name })
setMsg('Created')
setName('')
onDone?.()
}catch(e){ setMsg(e.response?.data?.msg || 'Error') }
}


return (
<form onSubmit={submit}>
<select className="w-full p-2 border rounded mb-2" value={methodId} onChange={e=>setMethodId(e.target.value)} required>
<option value="">Select method</option>
{methods.map(m=> <option key={m._id} value={m._id}>{m.name}</option>)}
</select>
<input required value={name} onChange={e=>setName(e.target.value)} placeholder="medicines" className="w-full p-2 border rounded mb-2" />
<button className="w-full bg-green-600 text-white p-2 rounded">Create</button>
{msg && <p className="mt-2">{msg}</p>}
</form>
)
}