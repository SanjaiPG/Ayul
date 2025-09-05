import React, { useEffect, useState } from 'react'
import CategoryForm from '../ui/CategoryForm'
import ItemForm from '../ui/ItemForm'
import API from "../api"; 
import MethodForm from "../ui/MethodForm"; 
import MethodsList from "../ui/MethodsList";

export default function Dashboard(){
const [methods, setMethods] = useState([])
const [refreshKey, setRefreshKey] = useState(0)


useEffect(()=>{ fetchMethods() }, [refreshKey])


async function fetchMethods(){
try{
const res = await API.get('/api/methods')
setMethods(res.data)
}catch(e){ console.error(e) }
}


return (
<div className="p-6">
<div className="flex items-center justify-between mb-6">
<h1 className="text-3xl font-bold">Siddha Admin</h1>
<div>
<button onClick={()=>{ localStorage.clear(); window.location.href='/login' }} className="px-3 py-2 bg-red-500 text-white rounded">Logout</button>
</div>
</div>


<div className="grid grid-cols-3 gap-6">
<div className="col-span-1 bg-white p-4 rounded shadow">
<h2 className="font-semibold mb-2">Add Method</h2>
<MethodForm onDone={()=>setRefreshKey(k=>k+1)} />
</div>


<div className="col-span-1 bg-white p-4 rounded shadow">
<h2 className="font-semibold mb-2">Add Category</h2>
<CategoryForm methods={methods} onDone={()=>setRefreshKey(k=>k+1)} />
</div>


<div className="col-span-1 bg-white p-4 rounded shadow">
<h2 className="font-semibold mb-2">Add Item</h2>
<ItemForm methods={methods} onDone={()=>setRefreshKey(k=>k+1)} />
</div>
</div>


<div className="mt-6 bg-white p-4 rounded shadow">
<h2 className="font-semibold mb-3">Existing Methods</h2>
<MethodsList methods={methods} refresh={()=>setRefreshKey(k=>k+1)} />
</div>
</div>
)
}