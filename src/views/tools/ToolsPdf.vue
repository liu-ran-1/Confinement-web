<template>
  <div>
    <el-upload
      :show-file-list="false"
      :before-upload="beforeUpload"
      :on-success="onSuccess"
      :on-error="onError"
      :disabled="importDataDisabled"
      style="display: inline-flex; margin-right: 8px"
      action="/web/tools/pdf/upload"
    >
      <el-button
        :disabled="importDataDisabled"
        type="success"
        :icon="importDataBtnIcon"
      >
        {{ importDataBtnText }}
      </el-button>
    </el-upload>

    <p>{{ this.position }}</p>
  </div>
</template>

<script>
export default {
  name: "ToolsPdf",
  data() {
    return {
      position: "",
      importDataBtnText: "导入pdf",
      importDataBtnIcon: "el-icon-upload2",
      importDataDisabled: false,
      showAdvanceSearchView: false,
    };
  },
  mounted() {
    this.initPosition();
  },
  methods: {
    initPosition() {
      this.position = "这是一个pdf工具页面";
    },
    onError(err, file, fileList) {
      this.importDataBtnText = "导入数据";
      this.importDataBtnIcon = "el-icon-upload2";
      this.importDataDisabled = false;
    },
    onSuccess(response, file, fileList) {
      this.importDataBtnText = "导入数据";
      this.importDataBtnIcon = "el-icon-upload2";
      this.importDataDisabled = false;
      //   this.initEmps();
    },
    beforeUpload() {
      this.importDataBtnText = "正在导入";
      this.importDataBtnIcon = "el-icon-loading";
      this.importDataDisabled = true;
    },
  },
};
</script>

<style scoped>
/* 可以设置不同的进入和离开动画 */
/* 设置持续时间和动画函数 */
.slide-fade-enter-active {
  transition: all 0.8s ease;
}

.slide-fade-leave-active {
  transition: all 0.8s cubic-bezier(1, 0.5, 0.8, 1);
}

.slide-fade-enter, .slide-fade-leave-to
        /* .slide-fade-leave-active for below version 2.1.8 */ {
  transform: translateX(10px);
  opacity: 0;
}
</style>