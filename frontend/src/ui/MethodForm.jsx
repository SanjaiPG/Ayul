import React, { useState } from 'react'
import API from '../api'


export default function MethodForm({ onDone }){
const [name, setName] = useState('')
const [desc, setDesc] = useState('')
const [msg, setMsg] = useState('')


async function submit(e){
e.preventDefault()
try{
await API.post('/api/methods', { name, description: desc })
setMsg('Created')
setName(''); setDesc('')
onDone?.()
}catch(e){ setMsg(e.response?.data?.msg || 'Error') }
}


return (
<form onSubmit={submit}>
<input required value={name} onChange={e=>setName(e.target.value)} placeholder="Siddha" className="w-full p-2 border rounded mb-2" />
<textarea value={desc} onChange={e=>setDesc(e.target.value)} placeholder="description" className="w-full p-2 border rounded mb-2" />
<button className="w-full bg-green-600 text-white p-2 rounded">Create</button>
{msg && <p className="mt-2">{msg}</p>}
</form>
)
}