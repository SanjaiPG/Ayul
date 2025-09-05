import React from 'react'
import API from '../api'


export default function MethodsList({ methods, refresh }){
async function deleteMethod(id){
if(!window.confirm('Delete method?')) return;
try{ await API.delete(`/api/methods/${id}`); refresh(); }catch(e){ alert('Delete failed') }
}


return (
<div>
{methods.map(m=> (
<div key={m._id} className="p-3 border-b">
<div className="flex justify-between items-center">
<div>
<div className="font-semibold">{m.name}</div>
<div className="text-sm text-gray-500">{m.description}</div>
</div>
<div>
<button onClick={()=>deleteMethod(m._id)} className="px-2 py-1 bg-red-500 text-white rounded">Delete</button>
</div>
</div>
<div className="mt-2 grid grid-cols-3 gap-2">
{m.categories?.map(c=> (
<div key={c._id} className="p-2 bg-gray-50 rounded">
<div className="font-medium">{c.name}</div>
<div className="text-sm text-gray-500">Items: {c.items?.length || 0}</div>
</div>
))}
</div>
</div>
))}
</div>
)
}