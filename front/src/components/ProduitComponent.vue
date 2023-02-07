<template>
 <div>
   <p>{{ leProduit.nom }}</p>
   <p>{{ leProduit.description }}</p>
   <p>{{ leProduit.prix }}</p>
   <button v-on:click="ajouterAuPanier" v-show="showATC">ajouter au panier</button>
 </div>
</template>

<script>
export default {
  name: "ProduitComponent",
  props: ["produit", "showAAP"],
  data: () => ({
    leProduit: {nom: "", description: "", prix: 0.0},
    showATC: false,
  }),
  methods: {
    ajouterAuPanier() {
      this.$emit("addToPanier", this.produit);
    }
  },
  mounted() {
    this.leProduit = this.produit;
    this.showATC = this.showAAP;
  }
}
</script>

<style scoped>
div {
  background-color: white;
  color: black;
}
</style>