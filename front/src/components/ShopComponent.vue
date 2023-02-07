<template>
  <button v-on:click="moveToPanier">Mon panier</button>
  <select v-model="marchandSelected">
    <option v-for="marchand of marchands" v-bind:value="marchand" v-bind:key="marchand">
      {{ marchand.nom }}
    </option>
  </select>
  <button v-on:click="changeCard">choisir ce commercant</button>

  <div v-for="produit in produits" :key="produit">
    <ProduitComponent :produit="produit" :showAAP="true" @addToPanier="addToPanier"/>
  </div>
</template>

<script>
import {ServiceMarchand} from "../../src/assets/js/services/ServiceMarchand.js";
import {ServiceProduit} from "../../src/assets/js/services/ServiceProduit.js";
import ProduitComponent from "./ProduitComponent";

export default {
  name: "ShopComponent",
  components: {ProduitComponent},
  data: () => ({
    marchands: [],
    marchandSelected: null,
    produits: [],
  }),
  methods: {
    changeCard() {
      ServiceProduit.getAllProduitByMarchand(this.marchandSelected).then(async (response) => {
        this.produits = response;
      })
    },
    addToPanier(produit) {
      this.$emit("addToCart", produit);
    },
    moveToPanier() {
      this.$emit("changePage", "cart");
    }
  },
  mounted() {
    ServiceMarchand.getAll().then(async (response) => {
      this.marchands = response;
    })
  }
}
</script>

<style scoped>

</style>