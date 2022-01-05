using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class list : MonoBehaviour
{
    //private Text scoreText;
    //private int score = 0;
    // Start is called before the first frame update

    private void Awake()
    {
        //scoreText = GetComponent<Text>();
        transform.Find("lists").GetComponent<Button>().onClick.AddListener(() =>
        {
            Time.timeScale = 0;
            EventCenter.Broadcast(EventDefine.pausePanelScene, true);
            Show(false);
        });

        EventCenter.AddListener<bool>(EventDefine.IsShowList, Show);

        //EventCenter.AddListener<int>(EventDefine.getPoint, UpdateScore);
    }
    private void OnDestroy()
    {
        EventCenter.RemoveListener<bool>(EventDefine.IsShowList, Show);
        //EventCenter.RemoveListener<int>(EventDefine.getPoint, UpdateScore);
    }
    private void Show(bool value)
    {
        gameObject.SetActive(value);
    }

    //private void UpdateScore(int score)
    //{
    //score = score + 1;
    //scoreText.text = score.ToString();
    //}
}