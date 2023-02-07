<template>
  <div class="w-full  h-full flex flex-col space-y-4 justify-center">
    <div class="flex flex-col space-y-4 mt-10 rounded-xl mx-[40%] p-4  justify-center">
      <button class="mb-6 bg-[#ffc72c] p-4 rounded-xl" v-on:click="goToShop">Liste de produit</button>
      <button class="bg-[#ffc72c] p-4 rounded-xl" v-on:click="commander">Commander</button>
    </div>


    <div v-for="produit of panier" :key="produit">
      <ProduitComponent :produit="produit" :showAAP="false" :index="panier.findIndex((element) => element.id === produit.id && element.marchand.instance.id === produit.marchand.instance.id)" @removeToPanier="removeToPanier"/>
    </div>
  </div>
</template>

<script>
import ProduitComponent from "./ProduitComponent";
import {ServiceCommande} from "@/assets/js/services/ServiceCommande";

export default {
  name: "CartComponent",
  props: ["panier"],
  components: {
    ProduitComponent,
  },

  methods: {
    goToShop() {
      this.$emit("changePage", "shop");
    },
    commander() {
      ServiceCommande.save(this.panier).then((response) => {
        this.$emit("clearPanier");
        return response;
      });
    },
    removeToPanier(indexProduit) {
      this.$emit("removeToCart", indexProduit);
    }
  }
}
</script>

<style scoped>

</style>