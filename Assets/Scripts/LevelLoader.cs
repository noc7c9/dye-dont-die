using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Noc7c9.DyeDontDie {

    public class LevelLoader : MonoBehaviour {

        const string HOLDER = "Holder";

        [Range(0, 1)]
        public float enemySpawnChance;

        [Range(0, 1)]
        public float enemyOutlineWhiteChance;
        [Range(0, 1)]
        public float enemySolidColorChance;

        public Transform[] enemyPrefabs;

        public Transform tilePrefab;
        public float tileSize;

        public Transform player;

        public float offloadMinDistance;
        public int totalLoadedChunks;

        int[][,] mapChunks = new int[][,] {
            new int[,] {
                {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                {0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0},
                {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
            },
            new int[,] {
                {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                {0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1},
                {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
            },
            new int[,] {
                {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                {1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1},
                {1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1},
                {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0},
                {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
            },
            new int[,] {
                {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                {1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0},
                {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
            },
        };

        List<Transform> holderLists = new List<Transform>();
        int lastChunkId;
        float chunkOffset;

        float initialYOffset;

        void Awake() {
            initialYOffset = transform.position.y - player.position.y;
        }

        void Update() {
            float playerY = player.position.y;
            if (holderLists.Count > 0) {
                Transform topMostHolder = holderLists[0];
                if (topMostHolder.position.y > (playerY + offloadMinDistance)) {
                    holderLists.Remove(topMostHolder);
                    Destroy(topMostHolder.gameObject);

                    CreateChunk();
                }
            }
        }

        public void StartLoading() {
            foreach (Transform holder in holderLists) {
#if UNITY_EDITOR
                DestroyImmediate(holder.gameObject);
#else
                Destroy(holder.gameObject);
#endif
            }
            holderLists = new List<Transform>();

            Vector3 newPosition = transform.position;
            newPosition.y = initialYOffset + player.position.y;
            transform.position = newPosition;

            lastChunkId = 0;
            chunkOffset = 0;

            // first platform is a set
            CreateChunk(0, false, false);

            for (int i = 0; i < totalLoadedChunks; i++) {
                CreateChunk();
            }

            this.enabled = true;
        }

        public void StopLoading() {
            this.enabled = false;
        }

        void CreateChunk() {
            CreateChunk(
                    Random.Range(0, mapChunks.Length),
                    Random.value > 0.5f, Random.value > 0.5f);
        }

        void CreateChunk(int chunkIndex, bool vFlip, bool hFlip) {
            int[,] chunk = mapChunks[chunkIndex];

            Transform holder = new GameObject(HOLDER + lastChunkId).transform;
            holder.parent = transform;
            holderLists.Add(holder);

            int height = chunk.GetLength(0);
            int width = chunk.GetLength(1);

            for (int y = 0; y < height; y++) {
                Vector3 totalPosition = Vector3.zero;
                int scale = 0;
                for (int x = 0; x < width; x++) {
                    int tileX = hFlip ? width - x - 1 : x;
                    int tileY = vFlip ? height - y - 1 : y;
                    if (chunk[tileY, tileX] == 1) {
                        totalPosition += new Vector3(x, -y, 0);
                        scale += 1;
                    } else {
                        SpawnTile(holder, totalPosition * tileSize / scale, scale);
                        totalPosition = Vector3.zero;
                        scale = 0;

                        SpawnEnemy(holder, new Vector3(x, -y, 0) * tileSize);
                    }
                }
                SpawnTile(holder, totalPosition * tileSize / scale, scale);
            }

            holder.localPosition = Vector3.up * chunkOffset;

            chunkOffset -= height * tileSize;
            lastChunkId += 1;
        }

        void SpawnTile(Transform holder, Vector3 position, float scale) {
            if (scale <= 0) {
                return;
            }
            Transform tile = Instantiate(tilePrefab);
            tile.localPosition = position;
            tile.localScale = new Vector3(scale, 1, 1);
            tile.parent = holder;
        }

        void SpawnEnemy(Transform holder, Vector3 position) {
            if (Random.value > enemySpawnChance) {
                return;
            }

            Transform enemyPrefab = enemyPrefabs[Random.Range(0, enemyPrefabs.Length)];

            Transform enemyT = Instantiate(enemyPrefab);
            enemyT.parent = holder;
            enemyT.localPosition = position;

            // set enemy properties
            EnemyController enemy = enemyT.GetComponent<EnemyController>();

            enemy.colorIndex = Random.Range(
                    0, GameManager.Instance.GetNumberOfColors());

            // hardest to easiest
            if (Random.value < enemySolidColorChance) {
                enemy.enemyType = EnemyType.SOLID_COLOR;
            } else if (Random.value < enemyOutlineWhiteChance) {
                enemy.enemyType = EnemyType.OUTLINE_WHITE;
            } else {
                enemy.enemyType = EnemyType.SOLID_WHITE;
            }
        }

    }

}
