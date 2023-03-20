<template>
    <div>
        <el-form
                :rules="rules"
                ref="registerForm"
                v-loading="loading"
                element-loading-text="正在注册..."
                element-loading-spinner="el-icon-loading"
                element-loading-background="rgba(0, 0, 0, 0.8)"
                :model="registerForm"
                class="loginContainer">
            <h3 class="loginTitle">刘小然工作室</h3>
            <el-form-item prop="username">
                <el-input size="normal" type="text" v-model="registerForm.username" auto-complete="off"
                          placeholder="请输入用户名"></el-input>
            </el-form-item>
             <el-form-item prop="name">
                <el-input size="normal" type="text" v-model="registerForm.name" auto-complete="off"
                          placeholder="请输入昵称"></el-input>
            </el-form-item>
            <el-form-item prop="password">
                <el-input size="normal" type="password" v-model="registerForm.password" auto-complete="off"
                          placeholder="请输入密码"></el-input>
            </el-form-item>
             <el-form-item prop="phone">
                <el-input size="normal" type="text" v-model="registerForm.phone" auto-complete="off"
                          placeholder="请输入手机号"></el-input>
            </el-form-item>
            <el-form-item prop="telephone">
                <el-input size="normal" type="text" v-model="registerForm.telephone" auto-complete="off"
                          placeholder="请输入座机"></el-input>
            </el-form-item>
            <el-form-item prop="address">
                <el-input size="normal" type="text" v-model="registerForm.address" auto-complete="off"
                          placeholder="请输入地址"></el-input>
            </el-form-item>
             <el-form-item >
    <el-col >
      <el-date-picker type="date" placeholder="出生日期" v-model="registerForm.birthday" style="width: 100%;"></el-date-picker>
    </el-col>
  </el-form-item>
            <el-button size="normal" type="primary" style="width: 100%;" @click="submitRegister">注册</el-button>
        <p class="login" @click="gotoLogin">已有账号？立即登录</p>
        </el-form>
        
    </div>
</template>

<script>

    export default {
        name: "Login",
        data() {
            return {
                loading: false,
                vcUrl: '/verifyCode?time='+new Date(),
                registerForm: {
                    username: 'admin',
                    password: '123',
                    code:'',
                    birthday:'',
                    phone:'',
                    telephone:'',
                    name:'',
                    address:''
                },
                checked: true,
                rules: {
                    username: [{required: true, message: '请输入用户名', trigger: 'blur'}],
                    password: [{required: true, message: '请输入密码', trigger: 'blur'}],
                    code: [{required: true, message: '请输入验证码', trigger: 'blur'}]
                }
            }
        },
        methods: {
            submitRegister() {
                        this.loading = true;
                        this.postRequest('/register', this.registerForm).then(resp => {
                            this.loading = false;
                            if (resp) {
                                this.$store.commit('INIT_CURRENTHR', resp.obj);
                                window.sessionStorage.setItem("user", JSON.stringify(resp.obj));
                                // let path = this.$route.query.redirect;
                                // this.$router.replace((path == '/' || path == undefined) ? '/home' : path);
                                 this.$router.push({path: "/login"});
                            }
                        })                
            },
             // <!--进入登录页-->
    gotoLogin() {
      this.$router.push({
        path: "/login"
      });
    },
        }

    }
</script>

<style>
    .loginContainer {
        border-radius: 15px;
        background-clip: padding-box;
        margin: 180px auto;
        width: 350px;
        padding: 15px 35px 15px 35px;
        background: #fff;
        border: 1px solid #eaeaea;
        box-shadow: 0 0 25px #cac6c6;
    }

    .loginTitle {
        margin: 15px auto 20px auto;
        text-align: center;
        color: #505458;
    }

    .loginRemember {
        text-align: left;
        margin: 0px 0px 15px 0px;
    }
    .el-form-item__content{
        display: flex;
        align-items: center;
    }

       .login {
  margin-top: 10px;
  font-size: 14px;
  line-height: 22px;
  color: #1ab2ff;
  cursor: pointer;
  text-align: left;
  text-indent: 8px;
  text-align: center;
}
.login:hover {
  color: #2c2fd6;
}
</style>
