package com.yhschool.adapter

import android.content.Context
import android.util.SparseArray
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.databinding.ViewDataBinding
import androidx.recyclerview.widget.RecyclerView
import com.yhschool.base.ItemClick
import com.yhschool.data.VideoData
import com.yhschool.base.BaseAdapter
import com.yhschool.evts.CallBack
import com.yhschool.R

class VideoAdapter(
        var context: Context,
        var list: ArrayList<VideoData.Data>,
        val clickEvt: CallBack
): RecyclerView.Adapter<VideoAdapter.VH>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VH {
        var view = LayoutInflater.from(context).inflate(R.layout.item_play_list,parent,false)
        return VH(view)
    }

    override fun onBindViewHolder(holder: VH, position: Int) {
        holder.txtName.setText(list.get(position).name)
        holder.itemView.setOnClickListener({
            if(clickEvt != null){
                clickEvt.onClick(list.get(position))
            }
        })
    }
    
    fun addData(_list:List<VideoData.Data>){
        list.clear()
        list.addAll(_list)
        notifyDataSetChanged()
    }
    
    override fun getItemCount(): Int {
        return list.size
    }

    inner class VH(itemView: View) : RecyclerView.ViewHolder(itemView){
        var txtName = itemView.findViewById<TextView>(R.id.txt_name)
        var txtPlay = itemView.findViewById<TextView>(R.id.txt_play)
    }
}