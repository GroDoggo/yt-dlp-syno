const express = require('express');
const { exec } = require('child_process');
const path = require('path');

const app = express();
const port = 7566;

// Servir les fichiers statiques (index.html)
app.use(express.static(path.join(__dirname, 'public')));

// Parse les requêtes POST en JSON
app.use(express.json());

// Route POST pour télécharger la vidéo via yt-dlp
app.post('/download', (req, res) => {
  const videoUrl = req.body.url;
  if (!videoUrl) {
    return res.status(400).send('URL manquante');
  }

  // Commande pour télécharger la vidéo
  const command = `yt-dlp ${videoUrl}`;

  exec(command, (error, stdout, stderr) => {
    if (error) {
      console.error(`Erreur lors du téléchargement : ${error.message}`);
      return res.status(500).send('Erreur lors du téléchargement');
    }
    if (stderr) {
      console.error(`Erreur : ${stderr}`);
    }
    console.log(`Résultat : ${stdout}`);
    res.send('Téléchargement terminé !');
  });
});

// Démarrer le serveur
app.listen(port, () => {
  console.log(`Serveur Node en écoute sur http://localhost:${port}`);
});
