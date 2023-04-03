<template>
    <div>
        <div>
            <div style="display: flex;justify-content: space-between">
                <div>
                    <el-input placeholder="请输入客户名称进行搜索，可以直接回车搜索..." prefix-icon="el-icon-search"
                              clearable
                              @clear="initCustomers"
                              style="width: 350px;margin-right: 10px" v-model="keyword"
                              @keydown.enter.native="initCustomers" :disabled="showAdvanceSearchView"></el-input>
                    <el-button icon="el-icon-search" type="primary" @click="initCustomers" :disabled="showAdvanceSearchView">
                        搜索
                    </el-button>
                    <el-button type="primary" @click="showAdvanceSearchView = !showAdvanceSearchView">
                        <i :class="showAdvanceSearchView?'fa fa-angle-double-up':'fa fa-angle-double-down'"
                           aria-hidden="true"></i>
                        高级搜索
                    </el-button>
                </div>
                <div>
                    <el-upload
                            :show-file-list="false"
                            :before-upload="beforeUpload"
                            :on-success="onSuccess"
                            :on-error="onError"
                            :disabled="importDataDisabled"
                            style="display: inline-flex;margin-right: 8px"
                            action="/web/employee/basic/import">
                        <el-button :disabled="importDataDisabled" type="success" :icon="importDataBtnIcon">
                            {{importDataBtnText}}
                        </el-button>
                    </el-upload>
                    <el-button type="success" @click="exportData" icon="el-icon-download">
                        导出数据
                    </el-button>
                    <el-button type="primary" icon="el-icon-plus" @click="showAddEmpView">
                        添加顾客
                    </el-button>
                </div>
            </div>
            <transition name="slide-fade">
                <div v-show="showAdvanceSearchView"
                     style="border: 1px solid #409eff;border-radius: 5px;box-sizing: border-box;padding: 5px;margin: 10px 0px;">
                    <el-row style="margin-top: 10px">
                        <el-col :span="10">
                            入住日期:
                            <el-date-picker
                                    v-model="searchValue.beginDateScope"
                                    type="daterange"
                                    size="mini"
                                    unlink-panels
                                    value-format="yyyy-MM-dd"
                                    range-separator="至"
                                    start-placeholder="开始日期"
                                    end-placeholder="结束日期">
                            </el-date-picker>
                        </el-col>
                        <el-col :span="5" :offset="4">
                            <el-button size="mini" icon="el-icon-search" type="primary" @click="initCustomers('advanced')">搜索</el-button>
                        </el-col>
                    </el-row>
                </div>
            </transition>
        </div>
        <div style="margin-top: 10px">
            <el-table
                    :data="emps"
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
                        prop="cusName"
                        fixed
                        align="left"
                        label="姓名"
                        width="90">
                </el-table-column>
                <el-table-column
                        prop="roomNo"
                        label="房间号"
                        align="left"
                        width="85">
                </el-table-column>
                <el-table-column
                        prop="startDate"
                        label="入住日期"
                        align="left"
                        width="95">
                </el-table-column>
                <el-table-column
                        prop="endDate"
                        width="95"
                        align="left"
                        label="终止日期">
                </el-table-column>
                <el-table-column
                        prop="telphone"
                        width="100"
                        align="left"
                        label="手机号">
                </el-table-column>
                <el-table-column
                        prop="email"
                        width="150"
                        align="left"
                        label="邮箱">
                </el-table-column>
                <el-table-column
                        prop="address"
                        width="220"
                        align="left"
                        label="联系地址">
                </el-table-column>

                <el-table-column
                        prop="favFoodCategory"
                        width="150"
                        align="left"
                        label="喜爱食材种类">
                </el-table-column>
                <el-table-column
                        prop="forbidFoodCategory"
                        width="150"
                        align="left"
                        label="禁忌食材种类">
                </el-table-column>
                <el-table-column
                        fixed="right"
                        width="200"
                        label="操作">
                    <template slot-scope="scope">
                        <el-button @click="showEditEmpView(scope.row)" style="padding: 3px" size="mini">编辑</el-button>
                        <el-button style="padding: 3px" size="mini" type="primary">查看高级资料</el-button>
                        <el-button @click="deleteEmp(scope.row)" style="padding: 3px" size="mini" type="danger">删除
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
                <el-form :model="emp" :rules="rules" ref="empForm">
                    <el-row>
                        <el-col :span="6">
                            <el-form-item label="姓名:" prop="cusName">
                                <el-input :disabled="cusNameDisable"  size="mini" style="width: 150px" prefix-icon="el-icon-edit" v-model="emp.cusName"
                                          placeholder="请输入员工姓名"></el-input>
                            </el-form-item>
                        </el-col>
                        <el-col :span="6">
                            <el-form-item label="房间号:" prop="roomNo">
                                <el-input size="mini" style="width: 150px" prefix-icon="el-icon-edit" v-model="emp.roomNo"
                                          placeholder="请输入房间号"></el-input>
                            </el-form-item>
                        </el-col>
                       <el-col :span="6">
                            <el-form-item label="入住日期:" prop="startDate">
                                <el-date-picker
                                        v-model="emp.startDate"
                                        size="mini"
                                        type="date"
                                        value-format="yyyy-MM-dd"
                                        style="width: 130px;"
                                        placeholder="入住日期">
                                </el-date-picker>
                            </el-form-item>
                        </el-col>
                        <el-col :span="6">
                            <el-form-item label="离店日期:" prop="endDate">
                                <el-date-picker
                                        v-model="emp.endDate"
                                        size="mini"
                                        type="date"
                                        value-format="yyyy-MM-dd"
                                        style="width: 130px;"
                                        placeholder="离店日期">
                                </el-date-picker>
                            </el-form-item>
                        </el-col>
                    </el-row>
                    <el-row>
                        <el-col :span="6">
                            <el-form-item label="电子邮箱:" prop="email">
                                <el-input size="mini" style="width: 150px" prefix-icon="el-icon-message"
                                          v-model="emp.email" placeholder="请输入电子邮箱"></el-input>
                            </el-form-item>
                        </el-col>
                        <el-col :span="7">
                            <el-form-item label="联系地址:" prop="address">
                                <el-input size="mini" style="width: 200px" prefix-icon="el-icon-edit"
                                          v-model="emp.address" placeholder="请输入联系地址"></el-input>
                            </el-form-item>
                        </el-col>
                         <el-col :span="7">
                            <el-form-item label="电话号码:" prop="telphone">
                                <el-input size="mini" style="width: 200px" prefix-icon="el-icon-phone"
                                          v-model="emp.telphone" placeholder="电话号码"></el-input>
                            </el-form-item>
                        </el-col>
                    </el-row>
                    <el-row>
                          <el-col :span="6">
                            <el-form-item label="喜爱食材:" prop="forbidFoodCategory">
                                <el-select v-model="emp.forbidFoodCategory" placeholder="职位" size="mini" style="width: 150px;" multiple=true>
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
                            <el-form-item label="禁忌食材:" prop="favFoodCategory">
                                <el-select v-model="emp.favFoodCategory" placeholder="职位" size="mini" style="width: 150px;" multiple=true>
                                    <el-option
                                            v-for="item in foodMaterials"
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
    <el-button type="primary" @click="doAddEmp">确 定</el-button>
  </span>
        </el-dialog>
    </div>
</template>

<script>
    export default {
        name: "CusBasic",
        data() {
            return {
                searchValue: {
                    politicId: null,
                    nationId: null,
                    jobLevelId: null,
                    posId: null,
                    engageForm: null,
                    departmentId: null,
                    beginDateScope: null,
                    foodMaterials:null
                },
                title: '',
                importDataBtnText: '导入数据',
                importDataBtnIcon: 'el-icon-upload2',
                importDataDisabled: false,
                showAdvanceSearchView: false,
                allDeps: [],
                emps: [],
                loading: false,
                popVisible: false,
                popVisible2: false,
                dialogVisible: false,
                cusNameDisable: false,
                total: 0,
                page: 1,
                keyword: '',
                size: 10,
                nations: [],
                joblevels: [],
                foodMaterials:[],
                politicsstatus: [],
                positions: [],
                tiptopDegrees: ['本科', '大专', '硕士', '博士', '高中', '初中', '小学', '其他'],
                options: [{
                    value: '选项1',
                    label: '黄金糕'
                }],
                inputDepName: '所属部门',
                emp: {},
                defaultProps: {
                    children: 'children',
                    label: 'name'
                },
                rules: {
                    name: [{required: true, message: '请输入用户名', trigger: 'blur'}],
                    gender: [{required: true, message: '请输入性别', trigger: 'blur'}],
                    birthday: [{required: true, message: '请输入出生日期', trigger: 'blur'}],
                    idCard: [{required: true, message: '请输入身份证号码', trigger: 'blur'}, {
                        pattern: /(^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$)|(^[1-9]\d{5}\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{2}$)/,
                        message: '身份证号码格式不正确',
                        trigger: 'blur'
                    }],
                    wedlock: [{required: true, message: '请输入婚姻状况', trigger: 'blur'}],
                    nationId: [{required: true, message: '请输入您组', trigger: 'blur'}],
                    nativePlace: [{required: true, message: '请输入籍贯', trigger: 'blur'}],
                    politicId: [{required: true, message: '请输入政治面貌', trigger: 'blur'}],
                    email: [{required: true, message: '请输入邮箱地址', trigger: 'blur'}, {
                        type: 'email',
                        message: '邮箱格式不正确',
                        trigger: 'blur'
                    }],
                    phone: [{required: true, message: '请输入电话号码', trigger: 'blur'}],
                    address: [{required: true, message: '请输入员工地址', trigger: 'blur'}],
                    departmentId: [{required: true, message: '请输入部门名称', trigger: 'blur'}],
                    jobLevelId: [{required: true, message: '请输入职称', trigger: 'blur'}],
                    posId: [{required: true, message: '请输入职位', trigger: 'blur'}],
                    engageForm: [{required: true, message: '请输入聘用形式', trigger: 'blur'}],
                    tiptopDegree: [{required: true, message: '请输入学历', trigger: 'blur'}],
                    specialty: [{required: true, message: '请输入专业', trigger: 'blur'}],
                    school: [{required: true, message: '请输入毕业院校', trigger: 'blur'}],
                    beginDate: [{required: true, message: '请输入入职日期', trigger: 'blur'}],
                    workState: [{required: true, message: '请输入工作状态', trigger: 'blur'}],
                    workID: [{required: true, message: '请输入工号', trigger: 'blur'}],
                    contractTerm: [{required: true, message: '请输入合同期限', trigger: 'blur'}],
                    conversionTime: [{required: true, message: '请输入转正日期', trigger: 'blur'}],
                    notworkDate: [{required: true, message: '请输入离职日期', trigger: 'blur'}],
                    beginContract: [{required: true, message: '请输入合同起始日期', trigger: 'blur'}],
                    endContract: [{required: true, message: '请输入合同结束日期', trigger: 'blur'}],
                    workAge: [{required: true, message: '请输入工龄', trigger: 'blur'}],
                }
            }
        },
        mounted() {
            this.initCustomers();
            this.initData();
            this.initPositions();
        },
        methods: {
            searvhViewHandleNodeClick(data) {
                this.inputDepName = data.name;
                this.searchValue.departmentId = data.id;
                this.popVisible2 = !this.popVisible2
            },
            onError(err, file, fileList) {
                this.importDataBtnText = '导入数据';
                this.importDataBtnIcon = 'el-icon-upload2';
                this.importDataDisabled = false;
            },
            onSuccess(response, file, fileList) {
                this.importDataBtnText = '导入数据';
                this.importDataBtnIcon = 'el-icon-upload2';
                this.importDataDisabled = false;
                this.initCustomers();
            },
            beforeUpload() {
                this.importDataBtnText = '正在导入';
                this.importDataBtnIcon = 'el-icon-loading';
                this.importDataDisabled = true;
            },
            exportData() {
                window.open('/employee/basic/export', '_parent');
            },
            emptyEmp() {
                   this.cusNameDisable=false;
                this.emp = {
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
            showEditEmpView(data) {
                this.title = '编辑员工信息';
                this.emp = data;
                this.cusNameDisable=true;
                this.dialogVisible = true;
            },
            deleteEmp(data) {
                this.$confirm('此操作将永久删除【' + data.cusName + '】用户, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    this.deleteRequest("/customer/delete/" + data.id).then(resp => {
                        if (resp) {
                            this.initCustomers();
                        }
                    })
                }).catch(() => {
                    this.$message({
                        type: 'info',
                        message: '已取消删除'
                    });
                });
            },
            doAddEmp() {
                    this.$refs['empForm'].validate(valid => {
                        if (valid) {
                            this.putRequest("/customer/saveOrUpdate", this.emp).then(resp => {
                                if (resp) {
                                    this.dialogVisible = false;
                                    this.initCustomers();
                                }
                            })
                        }
                    });
            },
            handleNodeClick(data) {
                this.inputDepName = data.name;
                this.emp.id = data.id;
                this.popVisible = !this.popVisible
            },
            showDepView() {
                this.popVisible = !this.popVisible
            },
            showDepView2() {
                this.popVisible2 = !this.popVisible2
            },
            initPositions() {
                this.getRequest('/employee/basic/positions').then(resp => {
                    if (resp) {
                        this.positions = resp;
                    }
                })
            },
            getMaxWordID() {
                this.getRequest("/employee/basic/maxWorkID").then(resp => {
                    if (resp) {
                        this.emp.workID = resp.obj;
                    }
                })
            },
            initData() {
                if (!window.sessionStorage.getItem("foodMaterials")) {
                    this.getRequest('/food/material').then(resp => {
                        if (resp) {
                            this.foodMaterials = resp.data;
                            console.log('foodmaterial->'+this.foodMaterials)
                            window.sessionStorage.setItem("foodMaterials", JSON.stringify(resp.data));
                        }
                    })
                    
                } else {
                    this.foodMaterials = JSON.parse(window.sessionStorage.getItem("foodMaterials"));
                    console.log('foodmarerial--->'+JSON.stringify(this.foodMaterials));
                    //  window.sessionStorage.setItem("foodMaterials", '');
                }
            
              
            },
            sizeChange(currentSize) {
                this.size = currentSize;
                this.initCustomers();
            },
            currentChange(currentPage) {
                this.page = currentPage;
                this.initCustomers('advanced');
            },
            showAddEmpView() {
                this.emptyEmp();
                this.title = '新增顾客';
                this.dialogVisible = true;
            },
            initCustomers(type) {
                this.loading = true;
                let url = '/customer/basic?page=' + this.page + '&size=' + this.size;
                if (type && type == 'advanced') {
                    if (this.searchValue.politicId) {
                        url += '&politicId=' + this.searchValue.politicId;
                    }
                    if (this.searchValue.nationId) {
                        url += '&nationId=' + this.searchValue.nationId;
                    }
                    if (this.searchValue.jobLevelId) {
                        url += '&jobLevelId=' + this.searchValue.jobLevelId;
                    }
                    if (this.searchValue.posId) {
                        url += '&posId=' + this.searchValue.posId;
                    }
                    if (this.searchValue.engageForm) {
                        url += '&engageForm=' + this.searchValue.engageForm;
                    }
                    if (this.searchValue.departmentId) {
                        url += '&departmentId=' + this.searchValue.departmentId;
                    }
                    if (this.searchValue.beginDateScope) {
                        url += '&beginDateScope=' + this.searchValue.beginDateScope;
                    }
                } else {
                    url += "&name=" + this.keyword;
                }
                this.getRequest(url).then(resp => {
                    this.loading = false;
                    if (resp) {
                        this.emps = resp.data;
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
