<template>
  <h1 class="text-3xl font-bold underline">test</h1>
  <AuthComponent v-if="page === 'auth'" @changePage="changePage"/>
  <ShopComponent v-else-if="page === 'shop'" @addToCart="addToCart" @changePage="changePage"/>
  <div v-else>
    <button v-on:click="changePage('shop')">Liste de produit</button>
    <button v-on:click="commander">commander</button>

    <div v-for="produit in panier" :key="produit">
      <ProduitComponent :produit="produit" :showAAP="false"/>
    </div>

    <span class="error">{{error}}</span>
    <span class="msg">{{msg}}</span>
  </div>
</template>

<script>
import AuthComponent from "./components/AuthComponent";
import ShopComponent from "./components/ShopComponent";
import ProduitComponent from "./components/ProduitComponent";
import {ServiceCommande} from "./assets/js/services/ServiceCommande";

export default {
  name: 'App',
  components: {
    AuthComponent,
    ShopComponent,
    ProduitComponent
  },
  data: () => ({
    page: localStorage.getItem("token") != null ? "shop" : "auth",
    panier: [],
    error: "",
    msg: ""
  }),

  methods: {
    changePage(value) {
      this.page = value;
    },
    commander() {
      ServiceCommande.save(this.panier);
    },
    addToCart(produit) {
      this.panier.push(produit);
    }
  },
}
</script>

<style>

/*@tailwind base;*/
/*@tailwind components;*/
/*@tailwind utilities;*/

body {
  background-color: black;
  color: white;
}

.error {
  color: red;
}

.msg {
  color: green;
}
</style>
