<template>
 <div>
    <div>
        <div>
            <div style="display: flex;justify-content: space-between">
                <div>
                    <el-input placeholder="请输入客户名称进行搜索，可以直接回车搜索..." prefix-icon="el-icon-search"
                              clearable
                              @clear="initDishes"
                              style="width: 350px;margin-right: 10px" v-model="keyword"
                              @keydown.enter.native="initDishes" ></el-input>
                    <el-button icon="el-icon-search" type="primary" @click="initDishes" >
                        搜索
                    </el-button>
                    
                </div>
                <div>
                    <el-button type="primary" icon="el-icon-plus" @click="showAddEmpView">
                        添加菜品
                    </el-button>
                </div>
            </div>
        </div>
        <div style="margin-top: 10px">
            <el-table
                    :data="dishList"
                    stripe
                    border
                    v-loading="loading"
                    element-loading-text="正在加载..."
                    element-loading-spinner="el-icon-loading"
                    element-loading-background="rgba(0, 0, 0, 0.3)"
                    style="width: 100%">
                <el-table-column
                        type="selection"
                        width="55">
                </el-table-column>
                <el-table-column
                        prop="foodName"
                        fixed
                        align="left"
                        label="菜品名称"
                        width="150">
                </el-table-column>
                <el-table-column
                        prop="materialNames"
                        label="食材"
                        align="left"
                        width="200">
                </el-table-column>
                <el-table-column
                        prop="isUseName"
                        label="状态"
                        align="left"
                        width="85">
                </el-table-column>
                
                <el-table-column
                        prop="remark"
                        width="150"
                        align="left"
                        label="备注">
                </el-table-column>
                <el-table-column
                        prop="createTime"
                        width="150"
                        align="left"
                        label="创建时间">
                </el-table-column>
                <el-table-column
                        prop="ts"
                        width="150"
                        align="left"
                        label="修改时间">
                </el-table-column>
                <el-table-column
                        fixed="right"
                        width="200"
                        label="操作">
                    <template slot-scope="scope">
                        <el-button @click="showEditDishView(scope.row)" style="padding: 3px" size="mini">编辑</el-button>
                        <el-button @click="deleteDish(scope.row)" style="padding: 3px" size="mini" type="danger">删除
                        </el-button>
                    </template>
                </el-table-column>
            </el-table>
            <div style="display: flex;justify-content: flex-end">
                <el-pagination
                        background
                        @current-change="currentChange"
                        @size-change="sizeChange"
                        layout="sizes, prev, pager, next, jumper, ->, total, slot"
                        :total="total">
                </el-pagination>
            </div>
        </div>
        <el-dialog
                :title="title"
                :visible.sync="dialogVisible"
                width="80%">
            <div>
                <el-form :model="dish" :rules="rules" ref="dishForm">
                    <el-row>
                        <el-col :span="6">
                            <el-form-item label="名称:" prop="foodName">
                                <el-input   size="mini" style="width: 150px" prefix-icon="el-icon-edit" v-model="dish.foodName"
                                          placeholder="请输菜品名称"></el-input>
                            </el-form-item>
                        </el-col>
                        <el-col :span="6">
                            <el-form-item label="备注:" prop="remark">
                                <el-input size="mini" style="width: 150px" prefix-icon="el-icon-edit" v-model="dish.remark"
                                          placeholder="请输入备注"></el-input>
                            </el-form-item>
                        </el-col>
                    </el-row>
                    <el-row>
                          <el-col :span="6">
                            <el-form-item label="食材" prop="materialIdList">
                                <el-select v-model="dish.materialIdList" placeholder="食材" size="mini" style="width: 150px;" multiple>
                                    <el-option
                                            v-for="item in foodMaterials"
                                            :key="item.id"
                                            :label="item.name"
                                            :value="item.id">
                                    </el-option>
                                </el-select>
                            </el-form-item>
                          </el-col>
                            <el-col :span="6">
                            <el-form-item label="是否启用" prop="isUse">
                                <el-select v-model="dish.isUse" placeholder="是否启用" size="mini" style="width: 150px;" >
                                    <el-option
                                            v-for="item in isUseList"
                                            :key="item.id"
                                            :label="item.name"
                                            :value="item.id">
                                    </el-option>
                                </el-select>
                            </el-form-item>
                          </el-col>
                    </el-row>
                </el-form>
            </div>
            <span slot="footer" class="dialog-footer">
    <el-button @click="dialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="doAddDish">确 定</el-button>
  </span>
        </el-dialog>
    </div>
 </div>
</template>

<script>
    export default {
        name: "DishLibrary",
        data() {
            return {
                searchValue: {
                    politicId: null,
                    nationId: null
                   
                },
               dishList:[],
                dish:{},
                keyword:'',
                loading: false,
                total: 0,
                page: 1,
                keyword: '',
                size: 10,
                title: '',
                  popVisible: false,
                popVisible2: false,
                dialogVisible: false,
                cusNameDisable: false,
                foodMaterials:[],
                isUseList:[{id:'1',name:'启用'},{id:'0',name:'停用'}],
                rules: {}
            }
        },
        mounted() {
            this.initDishes();
            this.initData();
            this.initPositions();
        },
        methods: {
            deleteDish(data) {
                this.$confirm('此操作将永久删除【' + data.cusName + '】食材, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    this.deleteRequest("/dish/delete/" + data.id).then(resp => {
                        if (resp) {
                            this.initDishes();
                        }
                    })
                }).catch(() => {
                    this.$message({
                        type: 'info',
                        message: '已取消删除'
                    });
                });
            },
            doAddDish() {
                    this.$refs['dishForm'].validate(valid => {
                        if (valid) {
                            this.putRequest("/dish/saveOrUpdate", this.dish).then(resp => {
                                if (resp) {
                                    this.dialogVisible = false;
                                    this.initDishes();
                                }
                            })
                        }
                    });
            },
            handleNodeClick(data) {
                this.dish.id = data.id;
                this.popVisible = !this.popVisible
            },
            showDepView() {
                this.popVisible = !this.popVisible
            },
            showDepView2() {
                this.popVisible2 = !this.popVisible2
            },
       showEditDishView(data) {
                this.title = '编辑员工信息';
                this.dish = data;
                this.cusNameDisable=true;
                this.dialogVisible = true;
            },
          
            initData() {
                // if (!window.sessionStorage.getItem("foodMaterials")) {
                    this.getRequest('/food/material').then(resp => {
                        if (resp) {
                            this.foodMaterials = resp.data;
                            console.log('foodmaterial->'+this.foodMaterials)
                            window.sessionStorage.setItem("foodMaterials", JSON.stringify(resp.data));
                        }
                    })
                    
                // } else {
                //     this.foodMaterials = JSON.parse(window.sessionStorage.getItem("foodMaterials"));
                //     console.log('foodmarerial--->'+JSON.stringify(this.foodMaterials));
                //      window.sessionStorage.setItem("foodMaterials", '');
                // }
            
              
            },
            sizeChange(currentSize) {
                this.size = currentSize;
                this.initDishes();
            },
            currentChange(currentPage) {
                this.page = currentPage;
                this.initDishes('advanced');
            },
             emptyDish() {
                   this.cusNameDisable=false;
                this.dish = {
                    cusName: "",
                    roomNo: "",
                    startDate: "",
                    endDate: "",
                    telphone: "",
                    email: "",
                    address: "",
                    favFoodCategory:"",
                    forbidFoodCategory:""
                    
                }
                this.inputDepName = '';
               
            },
            showAddEmpView() {
                this.emptyDish();
                this.title = '新增菜品';
                this.dialogVisible = true;
            },
            initDishes(type) {
                this.loading = true;
                let url = '/dish/list?page=' + this.page + '&size=' + this.size;
                    url += "&name=" + this.keyword;
                this.getRequest(url).then(resp => {
                    this.loading = false;
                    if (resp) {
                        this.dishList = resp.data;
                        console.log(resp.data)
                        this.total = resp.total;
                    }
                });
            }
        }
    }
</script>

<style>
    /* 可以设置不同的进入和离开动画 */
    /* 设置持续时间和动画函数 */
    .slide-fade-enter-active {
        transition: all .8s ease;
    }

    .slide-fade-leave-active {
        transition: all .8s cubic-bezier(1.0, 0.5, 0.8, 1.0);
    }

    .slide-fade-enter, .slide-fade-leave-to
        /* .slide-fade-leave-active for below version 2.1.8 */
    {
        transform: translateX(10px);
        opacity: 0;
    }
</style>
