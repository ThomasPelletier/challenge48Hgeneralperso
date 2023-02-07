<template>
    <input type="email" v-model="this.email" placeholder="email">
    <input type="password" v-model="this.password" placeholder="password">
    <button type="button" v-on:click="login">connecter</button>
    <button type="button" v-on:click="register">s'enregistrer</button>

    <span class="error">{{ error }}</span>
</template>

<script>

import {ServiceUtilisateur} from "../../src/assets/js/services/ServiceUtilisateurs.js";

export default {
  name: "AuthComponent",

  data: () => ({
    email: "",
    password: "",
    error: ""
  }),

  methods: {
    async register() {
      if(this.email.trim() !== "" && this.password.trim() !== "") {
        ServiceUtilisateur.register(this.email, this.password)
            .then(async (response) => {
              const result = await response.json();
              if(response.status === 200) {
                localStorage.setItem("token", result.message)
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

</style>