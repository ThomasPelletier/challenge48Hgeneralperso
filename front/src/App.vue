<template>
  <NavComponent :isConnected="isConnected" @changePage="changePage" @setIsConnected="setIsConnected"/>
  <AuthComponent v-if="page === 'auth'" @changePage="changePage" @setIsConnected="setIsConnected"/>
  <ShopComponent v-else-if="page === 'shop'" @addToCart="addToCart" @changePage="changePage"/>
  <CartComponent v-else-if="page === 'cart'" :panier="panier" @changePage="changePage" @clearPanier="clearPanier" @removeToCart="removeToCart"/>

  <span class="error">{{error}}</span>
  <span class="msg">{{msg}}</span>
</template>

<script>
import AuthComponent from "./components/AuthComponent";
import ShopComponent from "./components/ShopComponent";
import NavComponent from "./components/NavComponent";
import CartComponent from "./components/CartComponent";

export default {
  name: 'App',
  components: {
    NavComponent,
    AuthComponent,
    ShopComponent,
    CartComponent
  },
  data: () => ({
    page: localStorage.getItem("token") != null ? "shop" : "auth",
    panier: [],
    error: "",
    msg: "",
    isConnected: localStorage.getItem("token") !== null,
  }),

  methods: {
    changePage(value) {
      this.page = value;
    },
    addToCart(produit) {
      let indexOfProduit = this.panier.findIndex((element) => element.id === produit.id && element.marchand.instance.id === produit.marchand.instance.id) 
      if(indexOfProduit === -1) {
        this.panier.push(produit);
      }
    },
    setIsConnected(value) {
      this.isConnected = value;
    },
    clearPanier() {
      this.panier = [];
    },
    removeToCart(indexProduit) {
      this.panier.splice(indexProduit, 1);
    }
  },
}
</script>

<style>

@tailwind base;
@tailwind components;
@tailwind utilities;

html, body {
  background-color: #808080;
  margin:0;
  padding:0;
  height:100%;
}

.header {
  background-color: #ffc72c;
  padding: 10px;
  text-align: center;
}

.error {
  color: red;
}

.msg {
  color: green;
}
</style>
