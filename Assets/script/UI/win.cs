using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class win : MonoBehaviour
{
    private AsyncOperation ao;
    private void Awake()
    {
        gameObject.SetActive(false);
        EventCenter.AddListener<bool>(EventDefine.win, Show);
        transform.Find("quit").GetComponent<Button>().onClick.AddListener(() =>
        {
            ao = SceneManager.LoadSceneAsync("start");
        });
    }
    private void OnDestroy()
    {
        EventCenter.RemoveListener<bool>(EventDefine.win, Show);
    }
    private void Show(bool value)
    {
        gameObject.SetActive(value);
    }

}
