import React from 'react'
import { Routes, Route, Navigate } from 'react-router-dom'
import Login from './pages/Login'
import Dashboard from './pages/Dashboard'


function RequireAuth({ children }) {
const token = localStorage.getItem('token');
return token ? children : <Navigate to="/login" replace />;
}


export default function App() {
return (
<div className="min-h-screen bg-gray-50 text-gray-900">
<Routes>
<Route path="/login" element={<Login />} />
<Route path="/" element={<RequireAuth><Dashboard /></RequireAuth>} />
</Routes>
</div>
);
}