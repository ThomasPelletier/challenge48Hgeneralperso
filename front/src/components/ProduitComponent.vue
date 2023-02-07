<template>
 <div>
   <p>{{ leProduit.nom }}</p>
   <p>{{ leProduit.description }}</p>
   <p>{{ leProduit.prix }}</p>
   <input type="number" min="1" v-model="qte" v-show="showATC">
   <span v-show="!showATC">quantité: {{this.leProduit.qte}}</span>
   <button v-on:click="ajouterAuPanier" v-show="showATC">ajouter au panier</button>
 </div>
</template>

<script>
export default {
  name: "ProduitComponent",
  props: ["produit", "showAAP"],
  data: () => ({
    leProduit: {nom: "", description: "", prix: 0.0, qte: 1},
    showATC: false,
    qte: 1
  }),
  methods: {
    ajouterAuPanier() {
      this.prod = this.produit;
      this.prod.qte = this.qte;
      this.$emit("addToPanier", this.prod);
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