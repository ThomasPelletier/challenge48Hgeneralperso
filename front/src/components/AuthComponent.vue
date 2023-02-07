<template>
  <div class="flex flex-col mb-[30%] mt-[30%] items-center space-y-4 MyCenter">
    <input class="rounded-2xl text-center" type="email" v-model="this.email" placeholder="email">
    <input class="rounded-2xl text-center" type="password" v-model="this.password" placeholder="password">
    <button type="button" v-on:click="login">Connecter</button>
    <select v-model="type">
      <option value="client" selected>client</option>
      <option value="marchand">marchand</option>
    </select>
    <button type="button" v-on:click="register">S'enregistrer</button>
  </div>

    <span class="error">{{ error }}</span>
</template>

<script>

import {ServiceUtilisateur} from "../../src/assets/js/services/ServiceUtilisateurs.js";

export default {
  name: "AuthComponent",

  data: () => ({
    email: "",
    password: "",
    error: "",
    type: "client"
  }),

  methods: {
    async register() {
      if(this.email.trim() !== "" && this.password.trim() !== "" && this.type.trim() !== "") {
        ServiceUtilisateur.register(this.email, this.password, this.type)
            .then(async (response) => {
              const result = await response.json();
              if(response.status === 200) {
                localStorage.setItem("token", result.message);
                this.$emit("setIsConnected", true);
                this.$emit("changePage", "shop");
              } else {
                this.error = result.message;
              }
            });
      }
    },
    async login() {
      if(this.email.trim() !== "" && this.password.trim() !== "") {
        ServiceUtilisateur.login(this.email, this.password)
            .then(async (response) => {
              const result = await response.json();
              if(response.status === 200) {
                localStorage.setItem("token", result.message)
                this.$emit("setIsConnected", true);
                this.$emit("changePage", "shop");
              } else {
                this.error = result.message;
              }
            });
        }
    }
  }
}
</script>

<style scoped>
.MyCenter {
  position: absolute;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
}
div{
  margin-top: 20em;
  justify-content: space-between;
}

button {
  width: 180px;
    font-size: 12px;
    padding: 12px 0;
    background: #FFC72C;
    border: 0;
    border-radius: 20px;
    outline: none;
    margin-top: 30px;
}
</style>