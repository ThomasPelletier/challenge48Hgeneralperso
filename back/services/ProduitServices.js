import {database} from "../db/initDb.js";

export const ProduitServices = {
    getAll: async () => {
        let connexion = database.createConnexionInstance();
        let sql = `select * from Produit`;
        // const [rows, fields] = await connexion.query('SELECT * FROM Produit');
        let response = connexion.awaitQuery(sql);
        database.closeConnexion(connexion);
        // return rows;
        return response;
    },
    getAllByMarchand: async (marchandId) => {
        let connexion = database.createConnexionInstance();
        let sql = `select * from Produit where idMarchand = ${marchandId}`;
        let result = connexion.awaitQuery(sql);
        database.closeConnexion(connexion);
        return result;
    }
}