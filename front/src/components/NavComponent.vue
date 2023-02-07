<template>
  <div class="header flex">
    <img src="../../public/logo.png" height="10" width="512" alt="">
    <div class="space-x-10 flex justify-center w-full mr-[30%] items-center ">
      <button class="text-xl font-bold" v-on:click="goToShop">Shop</button>
      <button class="text-xl font-bold" v-on:click="goToLogin" v-if="!isConnected">Sign in / Log in</button>
      <button class="text-xl font-bold" v-on:click="logout" v-if="isConnected">Logout</button>
    </div>
    <button>
      <img src="" alt="">
    </button>
  </div>
</template>

<script>
export default {
  name: "NavComponent",
  props: ["isConnected"],

  methods: {
    goToShop() {
      this.$emit("changePage", "shop");
    },

    goToLogin() {
      this.$emit("changePage", "auth");
    },

    logout() {
      localStorage.removeItem("token");
      this.$emit("setIsConnected", false);
      this.goToLogin();
    }
  }
}
</script>

<style scoped>

</style>