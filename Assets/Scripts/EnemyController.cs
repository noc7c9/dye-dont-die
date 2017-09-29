using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Noc7c9.DyeDontDie {

    [SelectionBase]
    public class EnemyController : MonoBehaviour {

        public SpriteRenderer fill;
        public SpriteRenderer outline;
        public SpriteRenderer dotted;

        public int colorIndex;

        public EnemyType enemyType;

        public AudioClip enemyDeathSound;

        public bool canKillPlayer {
            get {
                switch (enemyType) {
                    case EnemyType.SOLID_WHITE:
                        return true;
                    case EnemyType.OUTLINE_WHITE:
                        return true;
                    case EnemyType.SOLID_COLOR:
                        return !GameManager.Instance.MatchesActiveColor(color);
                }
                return false;
            }
        }
        public bool canBeKilled {
            get {
                switch (enemyType) {
                    case EnemyType.SOLID_WHITE:
                        return true;
                    case EnemyType.OUTLINE_WHITE:
                        return GameManager.Instance.MatchesActiveColor(color);
                    case EnemyType.SOLID_COLOR:
                        return false;
                }
                return false;
            }
        }

        Color color;

        LayerMask normalLayerMask;
        LayerMask noPlayerCollisionsLayerMask;

        void Start() {
            color = GameManager.Instance.GetColorSafe(colorIndex);

            normalLayerMask = LayerMask.NameToLayer("Enemy");
            noPlayerCollisionsLayerMask = LayerMask.NameToLayer("EnemyNoPlayer");

            outline.enabled = false;
            dotted.enabled = false;
            switch (enemyType) {
                case EnemyType.SOLID_WHITE:
                    fill.color = Color.white;
                    break;
                case EnemyType.OUTLINE_WHITE:
                    outline.enabled = true;
                    fill.color = color;
                    break;
                case EnemyType.SOLID_COLOR:
                    fill.color = color;

                    GameManager.Instance.ChangedColor -= OnChangedColorHandler;
                    GameManager.Instance.ChangedColor += OnChangedColorHandler;

                    OnChangedColorHandler(GameManager.Instance.GetActiveColor());

                    break;
            }
        }

        void OnChangedColorHandler(Color color) {
            if (enemyType == EnemyType.SOLID_COLOR) {
                if (this.color == color) {
                    gameObject.layer = noPlayerCollisionsLayerMask;
                    dotted.enabled = true;
                } else {
                    gameObject.layer = normalLayerMask;
                    dotted.enabled = false;
                }
            }
        }

        void OnCollisionEnter2D(Collision2D col) {
            if (col.gameObject.tag != "Player") {
                return;
            }

            // contact direction check, too strict
            // ContactPoint2D contact = col.contacts[0];
            // if (canBeHoppedOn && contact.normal == Vector2.down) {

            // positional check, less strict
            if (canBeKilled && col.transform.position.y > transform.position.y) {
                // player is above player
                // so die
                GetComponent<DeathAnimation>().StartAnimation();
                enabled = false; // stop moving
                AudioManager.PlaySoundStatic(enemyDeathSound);
            } else {
                // otherwise, player dies
                if (canKillPlayer) {
                    col.gameObject.GetComponent<PlayerController>().Die();
                }
            }
        }

        void OnDestroy() {
            GameManager gm = GameManager.Instance;
            if (gm != null) {
                GameManager.Instance.ChangedColor -= OnChangedColorHandler;
            }
        }

    }

    public enum EnemyType {
        SOLID_WHITE, SOLID_COLOR, OUTLINE_WHITE
    }

}
