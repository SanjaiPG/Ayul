import React, { useState } from 'react'
import API from '../api'


export default function Login() {
const [email, setEmail] = useState('')
const [password, setPassword] = useState('')
const [err, setErr] = useState('')


async function submit(e) {
e.preventDefault();
try {
const res = await API.post('/api/auth/login', { email, password });
localStorage.setItem('token', res.data.token);
localStorage.setItem('user', JSON.stringify(res.data.user));
window.location.href = '/';
} catch (e) {
setErr(e.response?.data?.msg || 'Login failed');
}
}


return (
<div className="flex items-center justify-center h-screen">
<form onSubmit={submit} className="w-full max-w-md bg-white p-6 rounded-lg shadow">
<h2 className="text-2xl font-semibold mb-4">Admin Login</h2>
{err && <div className="bg-red-100 text-red-800 p-2 rounded mb-3">{err}</div>}
<label className="block mb-2">Email</label>
<input className="w-full p-2 border rounded mb-3" value={email} onChange={e=>setEmail(e.target.value)} />
<label className="block mb-2">Password</label>
<input type="password" className="w-full p-2 border rounded mb-4" value={password} onChange={e=>setPassword(e.target.value)} />
<button className="w-full bg-blue-600 text-white p-2 rounded">Login</button>
</form>
</div>
)
}