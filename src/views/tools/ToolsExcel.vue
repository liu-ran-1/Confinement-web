<template>
  <div>
        <p>{{this.position}}</p>
    </div>
</template>

<script>
export default {
  name:"ToolsExcel",
   data () {
    return {
      position:''
    }
  },
  mounted(){
    this.initPosition();
  },
  methods:{
initPosition(){
  this.position='这是一个excel工具页面'
}
  }

}
</script>

<style scoped>

</style>